import os,tempfile
import json
from pathlib import Path
from playwright.sync_api import sync_playwright,expect
url=os.environ.get('ECOAGENDA_TEST_BASE_URL', 'http://localhost/ecoagendafinal/login/administrador/').rstrip('/')+'/'
with sync_playwright() as p:
 browser=p.chromium.launch(executable_path=os.environ.get('ECOAGENDA_TEST_CHROMIUM'),headless=True,args=['--no-sandbox'])
 ctx=browser.new_context(viewport={'width':1400,'height':780})
 ctx.add_cookies([{'name':'PHPSESSID','value':os.environ['ECOAGENDA_TEST_SESSION'],'url':url}])
 page=ctx.new_page();errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
 for mode,total in [('demanda','6'),('locais','3')]:
  page.goto(url+f'mapa_pinhais.php?modo={mode}&mes=10&ano=2026',wait_until='networkidle')
  assert page.locator('#mapTotal strong').inner_text()==total
  canvas=page.locator('#mapCanvas');canvas.hover();before=page.locator('#zoomLevel').inner_text();page.mouse.wheel(0,-500);page.wait_for_timeout(450);assert page.locator('#zoomLevel').inner_text()!=before
  page.locator('#zoomHome').click();page.wait_for_timeout(400)
  if mode=='demanda':
   assert page.locator('.ranking-item').count()==15
   assert page.locator('.leaflet-geography-pane canvas').count()==0
   assert page.locator('.coleta-pin').count()==0
   paths=page.locator('.leaflet-neighborhoods-pane path')
   assert paths.count()==15
   paths.nth(5).hover(force=True);expect(page.locator('.district-tooltip')).to_be_visible();assert 'pedidos de coleta' in page.locator('.district-tooltip').inner_text()
   page.locator('#bairroSearch').fill('jardim amel');assert page.locator('.ranking-item').count()==1;page.locator('#bairroSearch').press('Enter');assert page.locator('#selectedName').inner_text()=='Jardim Amélia';page.locator('#bairroSearch').press('Escape');page.wait_for_timeout(450);assert page.locator('#zoomLevel').inner_text()=='100%'
  else:
   assert page.locator('.leaflet-geography-pane canvas').count()==1
   assert page.locator('.location-item').count()==3
   assert page.locator('.coleta-pin').count()+page.locator('.coleta-cluster').count()>0
   assert page.locator('.leaflet-neighborhoods-pane path[fill-opacity="0"]').count()==15
   assert page.locator('#unmappedNotice').is_hidden()
   page.locator('#bairroSearch').fill('jose');assert page.locator('.location-item').count()==2;page.locator('.location-item').first.click();page.wait_for_timeout(450);expect(page.locator('.leaflet-popup')).to_be_visible();assert 'aproximada' in page.locator('.leaflet-popup').inner_text();page.locator('#bairroSearch').press('Escape');page.wait_for_timeout(450);assert page.locator('#zoomLevel').inner_text()=='100%'
  page.screenshot(path=str(Path(tempfile.gettempdir()) / f'map-{mode}-v2.png'))
  for size in [(390,844),(760,920),(1400,780)]:
   page.set_viewport_size({'width':size[0],'height':size[1]});page.wait_for_timeout(150);assert page.evaluate('document.documentElement.scrollWidth <= innerWidth')
  page.goto(url+f'mapa_pinhais.php?modo={mode}&mes=1&ano=2020',wait_until='networkidle');assert page.locator('#mapTotal strong').inner_text()=='0'
 page.goto(url+'administrador.php',wait_until='networkidle');assert page.locator('.adm-mapa-card[data-map-mode]').count()==2
 for mode,total in [('demanda','6'),('locais','3')]:
  card=page.locator(f'.adm-mapa-card[data-map-mode="{mode}"]');expect(card.locator('.adm-mapa-total strong')).to_have_text(total);card.screenshot(path=str(Path(tempfile.gettempdir()) / f'dashboard-{mode}-v2.png'))
 assert not errors,errors
 print('PASS: both sections, wheel zoom, markers, neutral streets map, district tooltips, search, mobile, empty month and parent totals; no JS errors')
 browser.close()
