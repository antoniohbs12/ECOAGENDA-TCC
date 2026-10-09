"""Navegação e apresentação sobre sessões locais; nenhum formulário é enviado."""
import os
from playwright.sync_api import sync_playwright, expect
base=os.environ.get('ECOAGENDA_TEST_BASE','http://127.0.0.1:8081')
with sync_playwright() as p:
    browser=p.chromium.launch(executable_path='/usr/bin/chromium',args=['--no-sandbox'])
    def open_area(session,path):
        context=browser.new_context(viewport={'width':1600,'height':1000})
        context.add_cookies([{'name':'PHPSESSID','value':session,'url':base}])
        page=context.new_page();errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
        assert page.goto(base+'/login/'+path).status==200
        page.evaluate('document.fonts.ready')
        assert page.evaluate('document.fonts.check(\'600 14px "Montserrat"\')')
        return context,page,errors
    def filters(page):
        status=page.locator('.ea-order-filters:visible [data-ea-status]')
        prazo=page.locator('.ea-order-filters:visible [data-ea-prazo]')
        assert prazo.locator('option').evaluate_all('(els)=>els.map(e=>e.value)')==['todos','valido','vencido']
        status.select_option('concluido')
        cards=page.locator('.ea-orders-list>.ea-order-card:visible');assert cards.count()>0
        assert all(v=='concluido' for v in cards.evaluate_all('(els)=>els.map(e=>e.dataset.eaStatus)'))
        prazo.select_option('vencido');expect(cards).to_have_count(0)
        status.select_option('todos')
        assert cards.count()==page.locator('.ea-orders-list>.ea-order-card[data-ea-prazo="vencido"]').count()
        assert all(v=='vencido' for v in cards.evaluate_all('(els)=>els.map(e=>e.dataset.eaPrazo)'))
        # Vence hoje integra Dentro do prazo, independentemente da data da execução.
        page.locator('.ea-orders-list>.ea-order-card').first.evaluate("e=>e.dataset.eaPrazo='hoje'")
        prazo.select_option('valido');assert page.locator('.ea-order-card[data-ea-prazo="hoje"]:visible').count()>0
        prazo.select_option('todos')
        assert cards.locator('.mot-compact-info').count()==cards.count()
        assert cards.locator('button:visible').evaluate_all('(els)=>els.every(e=>e.textContent.includes("Ver detalhes"))')
    def mobile(page):
        page.set_viewport_size({'width':390,'height':844})
        assert page.evaluate('document.documentElement.scrollWidth<=innerWidth')
    resident,page,errors=open_area(os.environ['ECOAGENDA_RESIDENT_SESSION'],'dashboard_morador/dashboard_morador.php?secao=acompanhar')
    filters(page)
    for state in ['andamento','concluido','suspenso']:
        card=page.locator(f'.ea-orders-list>.ea-order-card[data-ea-status="{state}"]').first
        button=card.locator('[data-toggle-details]');button.click()
        modal=page.locator('#eaResidentModal');expect(modal).to_be_visible()
        if state=='suspenso':assert modal.locator('.ea-progress').count()==0
        else:
            expect(modal.locator('.ea-progress-step')).to_have_count(5)
            expect(modal.locator('[aria-current="step"]')).to_have_count(1)
            expect(modal.locator('.ea-progress-step.done')).to_have_count(3 if state=='andamento' else 4)
        page.keyboard.press('Shift+Tab');assert modal.evaluate('(e)=>e.contains(document.activeElement)')
        mobile(page)
        if state=='andamento':
            circles=modal.locator('.ea-progress-circle').evaluate_all('(els)=>els.map(e=>e.getBoundingClientRect().x)')
            assert len(set(circles))==1
        page.keyboard.press('Escape');expect(modal).to_be_hidden();expect(button).to_be_focused()
        assert card.locator('.tracking-detail-panel').count()==1
        page.set_viewport_size({'width':1600,'height':1000})
    # Abrir novamente e links diretos continuam funcionando.
    page.goto(base+'/login/dashboard_morador/dashboard_morador.php?secao=acompanhar#pedido-13')
    expect(page.locator('#eaResidentModal')).to_be_visible();page.keyboard.press('Escape')
    page.goto(base+'/login/dashboard_morador/novo_pedido.php')
    page.locator('#btnOutroEndereco').click();expect(page.locator('.other-address')).to_be_visible()
    page.locator('#btnUsarEndereco').click();expect(page.locator('.other-address')).to_be_hidden()
    page.goto(base+'/login/dashboard_morador/perfil.php')
    for tab in ['endereco','senha','geral']:
        page.locator(f'[data-tab="{tab}"]').click();expect(page.locator(f'#tab-{tab}')).to_be_visible()
    mobile(page);assert not errors,errors;resident.close()
    for role,session,path in [('secretary',os.environ['ECOAGENDA_SECRETARY_SESSION'],'secretaria/secretaria.php'),('admin',os.environ['ECOAGENDA_ADMIN_SESSION'],'administrador/administrador.php')]:
        context,page,errors=open_area(session,path)
        page.locator('.menu-link[data-section="pedidos"]').click();filters(page)
        cards=page.locator('#section-pedidos .ea-order-card:visible')
        for index in [0,1,0]:
            cards.nth(index).locator('.mot-compact-footer button').click()
            modal=page.locator('#modalDetalhes');expect(modal).to_be_visible()
            assert modal.locator('#modalEndereco').inner_text()!='—'
            assert 'Material de coleta' in modal.inner_text()
            assert modal.locator('#modalStatus').inner_text() in ['Agendado','Em análise','A caminho','Em andamento','Concluído','Suspenso']
            expect(modal.locator('.ea-modal-additions')).to_have_count(1)
            page.keyboard.press('Escape');expect(modal).to_be_hidden()
        cards.first.locator('.mot-compact-footer button').click()
        if role=='secretary':
            page.locator('#modalDetalhes .ea-detail-actions button',has_text='Editar').click()
            expect(page.locator('#modalEditar')).to_be_visible();assert page.locator('#editarDescricao').input_value()
        else:
            page.locator('#modalDetalhes .ea-detail-actions button',has_text='histórico').click()
            expect(page.locator('#modalHistoricoPedido')).to_be_visible()
        page.keyboard.press('Escape')
        page.locator('.menu-link[data-section="buscar"]').click();page.click('#tipoBuscaId');page.fill('#campoBuscaPedido','13');page.click('#buscarPedido')
        expect(page.locator('#resultadoPedidosBusca .pedido-card')).to_have_count(1)
        page.locator('#resultadoPedidosBusca .mot-compact-footer button').click();expect(page.locator('#modalDetalhes')).to_be_visible()
        assert '13' in page.locator('#modalPedidoId').inner_text();page.keyboard.press('Escape')
        sections=['novo'] if role=='secretary' else ['motoristas','secretarias','moradores']
        for section in sections:
            page.locator(f'.menu-link[data-section="{section}"]').click();expect(page.locator(f'#section-{section}')).to_be_visible()
        mobile(page)
        page.emulate_media(reduced_motion='reduce');page.locator('.menu-link[data-section="pedidos"]').click()
        page.wait_for_timeout(50);assert page.locator('#section-pedidos').evaluate('(e)=>e.getAnimations().length')==0
        cards.first.locator('.mot-compact-footer button').click();mobile(page)
        page.keyboard.press('Shift+Tab');assert page.locator('#modalDetalhes').evaluate('(e)=>e.contains(document.activeElement)')
        assert not errors,errors;context.close()
    browser.close()
    print('Morador, secretaria e ADM: filtros, etapas, detalhes, busca, ações, reabertura, teclado e celular OK; sem envio de formulários.')
