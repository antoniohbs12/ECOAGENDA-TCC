import os,tempfile
import json,re,time
from pathlib import Path
from playwright.sync_api import sync_playwright,expect
root=os.environ.get('ECOAGENDA_TEST_BASE_URL', 'http://localhost/ecoagendafinal/login/administrador/').rstrip('/')+'/'
with sync_playwright() as p:
 b=p.chromium.launch(executable_path=os.environ.get('ECOAGENDA_TEST_CHROMIUM'),headless=True,args=['--no-sandbox']);ctx=b.new_context(viewport={'width':1400,'height':780});ctx.add_cookies([{'name':'PHPSESSID','value':os.environ['ECOAGENDA_TEST_SESSION'],'url':root}]);page=ctx.new_page();errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
 page.goto(root+'mapa_pinhais.php?modo=locais&mes=10&ano=2026',wait_until='networkidle')
 cfg=page.evaluate('window.EcoAgendaMapa')
 assert ctx.request.get(root+'mapa_localizar.php').status==405
 assert ctx.request.post(root+'mapa_localizar.php',data={'enderecoId':1}).status==403
 response=ctx.request.post(root+'mapa_localizar.php',data={'enderecoId':1},headers={'X-Mapa-CSRF':cfg['csrf']})
 assert response.status==200 and response.json()['precisao']=='rua_aproximada'
 unauth=b.new_context();assert unauth.request.get(root+'mapa_pinhais.php?dados=1').status==403;assert unauth.request.post(root+'mapa_localizar.php',data={'enderecoId':1}).status==403;assert unauth.request.get(root+'gerar_relatorio.php').status==403;unauth.close()
 # Simular a indisponibilidade do serviço com locais sem coordenadas.
 def pending(route):
  response=route.fetch();raw=response.text();pattern=r'(window\.EcoAgendaMapa = )(.*?)(;</script>)';m=re.search(pattern,raw,re.S);data=json.loads(json.dumps(cfg))
  for loc in data['data']['locais']:loc['lat']=None;loc['lng']=None;loc['precisao']='pendente'
  route.fulfill(response=response,body=raw[:m.start(2)]+json.dumps(data)+raw[m.end(2):])
 page.route('**/mapa_pinhais.php?modo=locais&mes=10&ano=2026',pending)
 page.route('**/mapa_localizar.php',lambda route:route.fulfill(status=503,content_type='application/json',body='{"erro":"unavailable"}'))
 page.goto(root+'mapa_pinhais.php?modo=locais&mes=10&ano=2026',wait_until='networkidle')
 expect(page.locator('#retryLocations')).to_be_visible();assert page.locator('.coleta-pin').count()==0;assert page.locator('.location-item').count()==3;assert '3 coletas aguardam' in page.locator('#unmappedNotice').inner_text()
 page.unroute_all(behavior='wait')
 page.clock.install()
 page.goto(root+'mapa_pinhais.php?modo=demanda&mes=10&ano=2026',wait_until='networkidle');page.route('**/mapa_pinhais.php?dados=1**',lambda route:route.fulfill(status=503,body='unavailable'));page.clock.fast_forward(61000);expect(page.locator('#mapUpdated')).to_contain_text('últimos dados');assert page.locator('#mapTotal strong').inner_text()=='6';assert page.locator('.ranking-item').count()==15
 assert not errors,errors
 print('PASS: auth, CSRF, cached geocoding, geocoder failure without fictitious points, and preserving data on refresh failure')
 b.close()
