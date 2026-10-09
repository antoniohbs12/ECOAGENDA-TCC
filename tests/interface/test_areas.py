"""Valida apresentação e navegação usando sessões locais; não envia formulários."""
import os
from playwright.sync_api import sync_playwright, expect
base=os.environ.get('ECOAGENDA_TEST_BASE','http://127.0.0.1:8081')
with sync_playwright() as p:
    browser=p.chromium.launch(executable_path='/usr/bin/chromium',args=['--no-sandbox'])
    def open_area(session):
        context=browser.new_context(viewport={'width':1600,'height':1000})
        context.add_cookies([{'name':'PHPSESSID','value':session,'url':base}])
        page=context.new_page();errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
        return context,page,errors
    resident,page,errors=open_area(os.environ['ECOAGENDA_RESIDENT_SESSION'])
    def go(path):
        assert page.goto(base+'/login/'+path).status==200
        page.evaluate('document.fonts.ready')
        assert page.evaluate('document.fonts.check(\'600 14px "Montserrat"\')')
    go('dashboard_morador/dashboard_morador.php?secao=acompanhar')
    page.locator('[data-filter="concluido"]').click()
    visible=page.locator('.tracking-item:visible');assert visible.count()>0
    assert all(v=='concluido' for v in visible.evaluate_all('(els)=>els.map(e=>e.dataset.status)'))
    visible.first.locator('[data-toggle-details]').click()
    expect(visible.first.locator('.tracking-detail-panel')).to_be_visible()
    page.set_viewport_size({'width':390,'height':844})
    assert page.evaluate('document.documentElement.scrollWidth<=innerWidth')
    go('dashboard_morador/novo_pedido.php')
    page.locator('#btnOutroEndereco').click();expect(page.locator('.other-address')).to_be_visible()
    page.locator('#btnUsarEndereco').click();expect(page.locator('.other-address')).to_be_hidden()
    # A camada visual não pode impedir a ocultação de controles pela lógica da página.
    page.locator('#btnUsarEndereco').evaluate("e=>e.style.display='none'")
    expect(page.locator('#btnUsarEndereco')).to_be_hidden()
    go('dashboard_morador/perfil.php')
    for tab in ['endereco','senha','geral']:
        page.locator(f'[data-tab="{tab}"]').click();expect(page.locator(f'#tab-{tab}')).to_be_visible()
    assert page.evaluate('document.documentElement.scrollWidth<=innerWidth')
    assert not errors,errors
    resident.close()
    secretary,page,errors=open_area(os.environ['ECOAGENDA_SECRETARY_SESSION'])
    go('secretaria/secretaria.php')
    page.locator('[data-section="pedidos"]').click()
    page.locator('[data-filter="concluido"]').click()
    cards=page.locator('#section-pedidos .pedido-card:visible');assert cards.count()>0
    cards.first.locator('.btn-ver-pedido').click();expect(page.locator('#modalDetalhes')).to_be_visible();page.keyboard.press('Escape')
    cards.first.locator('.btn-editar').click();expect(page.locator('#modalEditar')).to_be_visible();assert page.locator('#editarDescricao').input_value();page.keyboard.press('Escape')
    page.locator('[data-section="buscar"]').click();page.click('#tipoBuscaId');page.fill('#campoBuscaPedido','13');page.click('#buscarPedido')
    expect(page.locator('#resultadoPedidosBusca .pedido-card')).to_have_count(1)
    page.locator('[data-section="novo"]').click();assert page.locator('#novoCpf').is_visible()
    page.set_viewport_size({'width':390,'height':844});assert page.evaluate('document.documentElement.scrollWidth<=innerWidth')
    page.emulate_media(reduced_motion='reduce');page.locator('[data-section="pedidos"]').click()
    page.wait_for_timeout(50);assert page.locator('#section-pedidos').evaluate('(e)=>e.getAnimations().length')==0
    assert not errors,errors
    secretary.close();browser.close()
    print('Morador e secretaria: filtros, detalhes, abas, endereços, busca, edição e celular OK; nenhum formulário enviado.')
