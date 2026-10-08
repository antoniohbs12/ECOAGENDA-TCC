import os
from playwright.sync_api import sync_playwright
with sync_playwright() as p:
 b=p.chromium.launch(executable_path='/usr/bin/chromium',args=['--no-sandbox'])
 c=b.new_context(viewport={'width':1600,'height':1000});c.add_cookies([{'name':'PHPSESSID','value':os.environ['ECOAGENDA_TEST_SESSION'],'url':os.environ.get('ECOAGENDA_TEST_URL', 'http://127.0.0.1:8081')}]);page=c.new_page();errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
 r=page.goto(os.environ.get('ECOAGENDA_TEST_URL', 'http://127.0.0.1:8081/login/motorista/motorista.php'));print('HTTP',r.status);page.wait_for_timeout(700)
 print('calendar',page.locator('.mot-day').count(),'pending',page.locator('.mot-demand-card').count(),'detailed',page.locator('.pedido-card').count());print(page.locator('#mot-demand-summary').inner_text())
 assert page.locator('.mot-waste-grid').count()==page.locator('.pedido-card').count()
 assert page.locator('.mot-day').count()==7
 week=page.locator('#mot-week-label').inner_text();page.click('#mot-next');assert page.locator('#mot-week-label').inner_text()!=week;page.click('#mot-current');assert page.locator('#mot-week-label').inner_text()==week
 page.click('[data-demand-filter="vencido"]');assert all(x=='vencido' for x in page.locator('.mot-demand-card:visible').evaluate_all('(els)=>els.map(x=>x.dataset.prazo)'))
 page.click('[data-demand-filter="todos"]');page.locator('[data-open-pedido]').first.click();assert page.locator('#section-pedidos').is_visible()
 assert page.locator('.mot-detail-deadline').count()==page.locator('.pedido-card').count()
 page.select_option('#mot-detail-filter','valido');assert all(x in ['valido','hoje'] for x in page.locator('.pedido-card:visible').evaluate_all('(els)=>els.map(x=>x.dataset.prazo)'))
 page.select_option('#mot-detail-filter','todos');page.locator('.pedido-card:visible .btn-detalhes').first.click();assert page.locator('#modalDetalhes').is_visible();page.keyboard.press('Escape')
 print('errors',errors);assert not errors
 
 page.locator('.menu-link[data-section="inicio"]').click();page.set_viewport_size({'width':390,'height':844});assert page.evaluate('document.documentElement.scrollWidth<=innerWidth')
 print('mobile width',page.evaluate('({viewport:innerWidth,body:document.documentElement.scrollWidth})'))
 b.close()
