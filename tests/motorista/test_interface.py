import os
from playwright.sync_api import sync_playwright
url=os.environ.get('ECOAGENDA_TEST_URL','http://127.0.0.1:8081/login/motorista/motorista.php')
with sync_playwright() as p:
    browser=p.chromium.launch(executable_path='/usr/bin/chromium',args=['--no-sandbox'])
    context=browser.new_context(viewport={'width':1600,'height':1000})
    context.add_cookies([{'name':'PHPSESSID','value':os.environ['ECOAGENDA_TEST_SESSION'],'url':url}])
    page=context.new_page(); errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
    assert page.goto(url).status==200
    assert page.locator('.mot-day').count()==7
    assert page.locator('.filtro').count()==0
    for select in ['#mot-detail-filter']:
        assert page.locator(select+' option').evaluate_all('(els)=>els.map(e=>e.value)')==['todos','valido','vencido']
    week=page.locator('#mot-week-label').inner_text();page.click('#mot-next');assert page.locator('#mot-week-label').inner_text()!=week
    page.click('#mot-current');assert page.locator('#mot-week-label').inner_text()==week
    assert page.locator('.mot-demands').count()==0
    assert 'VENCEM HOJE' not in page.locator('body').inner_text()
    page.locator('.mot-calendar-order',has_text='Pedido #10').click()
    assert page.locator('#modalDetalhes').is_visible()
    assert page.locator('#modalPedidoId').inner_text()=='Pedido #10'
    assert 'Prazo vencido' in page.locator('#mot-modal-prazo-texto').inner_text()
    page.locator('#mot-modal-actions button',has_text='Concluir coleta').click();assert page.locator('#modalConcluir').is_visible();assert not page.locator('#modalDetalhes').is_visible()
    page.keyboard.press('Escape')
    page.locator('.menu-link[data-section="pedidos"]').click()
    page.select_option('#mot-status-filter','andamento');page.select_option('#mot-detail-filter','vencido')
    assert page.locator('.pedido-card:visible').count()>0
    assert all(x==['andamento','vencido'] for x in page.locator('.pedido-card:visible').evaluate_all('(els)=>els.map(e=>[e.dataset.status,e.dataset.prazo])'))
    assert page.locator('.pedido-card:visible .pedido-meta').count()==0
    assert page.locator('.pedido-card:visible button:visible').evaluate_all('(els)=>els.every(e=>e.textContent.includes("Ver detalhes"))')
    # Hoje integra Dentro do prazo, sem opção separada. Simula apenas atributos da interface.
    page.locator('.pedido-card[data-status="andamento"]').first.evaluate("e=>e.dataset.prazo='hoje'")
    page.select_option('#mot-detail-filter','valido');assert page.locator('.pedido-card[data-prazo="hoje"]:visible').count()>0
    page.select_option('#mot-status-filter','concluido');page.select_option('#mot-detail-filter','todos')
    page.locator('.pedido-card:visible .btn-detalhes').first.click()
    assert page.locator('#modalTelefone').inner_text() in ['—','Restrito']
    page.keyboard.press('Escape');page.select_option('#mot-status-filter','todos')
    page.set_viewport_size({'width':390,'height':844});assert page.evaluate('document.documentElement.scrollWidth<=innerWidth')
    if os.environ.get('ECOAGENDA_SCREENSHOTS'):
        page.screenshot(path='/tmp/motorista-resumo.png',full_page=True)
        page.locator('.menu-link[data-section="inicio"]').click();page.screenshot(path='/tmp/motorista-dashboard.png',full_page=True)
    assert not errors, errors
    browser.close()
    print('Interface: calendário único, detalhes pelo pedido, filtros, ações e celular OK')
