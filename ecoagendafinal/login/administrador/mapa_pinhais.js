(() => {
  'use strict';
  const cfg = window.EcoAgendaMapa;
  const $ = id => document.getElementById(id);
  const canvas = $('mapCanvas');
  const state = $('mapState');
  if (!canvas || !cfg) return;
  if (!window.L || !cfg.geojson?.features?.length) {
    state.hidden = false;
    state.textContent = 'Não foi possível carregar o mapa. Recarregue a página ou confira os arquivos do módulo.';
    return;
  }
  const normalize = value => String(value ?? '').normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase().replace(/\s+/g, ' ').trim();
  const number = value => Number(value || 0).toLocaleString('pt-BR');
  const percent = value => `${Number(value || 0).toLocaleString('pt-BR', {maximumFractionDigits: 1})}%`;
  let data = cfg.data;
  let selected = null;
  let busy = false;
  let initialized = false;
  let resizeFrame;
  const layers = new Map();
  const palette = ['#edf3ef', '#c4dfcf', '#89c5a0', '#479e70', '#167347'];
  const safeValue = name => Math.max(0, Number(data.dados?.[name] || 0));
  const share = count => Number(data.total) > 0 ? count / Number(data.total) * 100 : 0;
  const color = count => palette[count === 0 ? 0 : Math.min(4, Math.max(1, Math.ceil(count / Math.max(1, Number(data.max)) * 4)))];

  const map = L.map(canvas, {zoomControl: false, scrollWheelZoom: false, minZoom: 11, maxZoom: 17, zoomSnap: 0.25, attributionControl: true});
  map.attributionControl.setPrefix(false);
  map.createPane('neighborhoods');
  map.getPane('neighborhoods').style.zIndex = 410;
  // Base vetorial local: ruas e hidrografia sem rótulos, sem chave de API
  // e sem depender de um serviço de tiles em cada abertura do dashboard.
  map.createPane('geography');
  map.getPane('geography').style.zIndex = 200;
  map.getPane('geography').style.pointerEvents = 'none';
  const baseRenderer = L.canvas({pane: 'geography', padding: 0.3});
  map.attributionControl.addAttribution('Base: &copy; <a href="https://www.openstreetmap.org/copyright" target="_blank" rel="noopener">OpenStreetMap</a> / <a href="https://carto.com/attributions" target="_blank" rel="noopener">CARTO</a>');
  let geography;
  function geographyStyle(feature) {
    const {layer, class: category} = feature.properties;
    const scale = Math.min(2.8, Math.pow(2, Math.max(0, map.getZoom() - 13) * 0.4));
    if (layer === 'transportation') {
      const main = ['motorway', 'trunk', 'primary'].includes(category);
      return {color: main ? '#c5c9c4' : '#ffffff', weight: (main ? 2.4 : 1.1) * scale, opacity: 0.92, fill: false};
    }
    if (layer === 'waterway') return {color: '#a9cbd6', weight: 1.1 * scale, opacity: 0.9, fill: false};
    const colors = {landcover: '#e0e9df', landuse: category === 'industrial' ? '#e5e8e5' : '#eef0ec', park: '#d6e3d3', water: '#b9d3dc'};
    return {stroke: false, fillColor: colors[layer] || '#edf1ed', fillOpacity: 1};
  }
  async function loadGeography() {
    try {
      const response = await fetch('pinhais_base.geojson?v=20261008-1');
      if (!response.ok) throw new Error('Base indisponível');
      const base = await response.json();
      if (base.type !== 'FeatureCollection' || !base.features?.length) throw new Error('Base inválida');
      geography = L.geoJSON(base, {pane: 'geography', renderer: baseRenderer, interactive: false, style: geographyStyle}).addTo(map);
      $('tileNotice').hidden = true;
    } catch {
      $('tileNotice').hidden = false;
    }
  }
  map.on('zoomend', () => { if (geography) geography.setStyle(geographyStyle); });

  function layerStyle(name, hover = false) {
    const active = name === selected;
    return {color: active ? '#054e31' : hover ? '#167347' : '#fafdfa', weight: active ? 3 : hover ? 2.5 : 1.4,
      fillColor: color(safeValue(name)), fillOpacity: safeValue(name) ? 0.48 : 0.16, opacity: 1};
  }
  function tooltip(name) {
    const node = document.createElement('div');
    const title = document.createElement('strong'); title.textContent = name;
    const text = document.createElement('span'); text.textContent = `${number(safeValue(name))} pedidos · ${percent(share(safeValue(name)))} do período`;
    node.append(title, text); return node;
  }
  const districts = L.geoJSON(cfg.geojson, {
    pane: 'neighborhoods', style: feature => layerStyle(feature.properties.bairro),
    onEachFeature(feature, layer) {
      const name = feature.properties.bairro;
      layers.set(name, layer);
      layer.bindTooltip(tooltip(name), {sticky: true, className: 'district-tooltip', direction: 'top'});
      layer.on({mouseover: () => { layer.setStyle(layerStyle(name, true)); layer.bringToFront(); },
        mouseout: () => { layer.setStyle(layerStyle(name)); if (selected) layers.get(selected)?.bringToFront(); },
        click: () => select(name, true)});
    }
  }).addTo(map);
  const bounds = districts.getBounds();
  map.setMaxBounds(bounds.pad(0.45));
  function zoomReadout() {
    if (!initialized) return;
    const fitZoom = map.getBoundsZoom(bounds, false, L.point(64, 146));
    $('zoomLevel').textContent = `${Math.round(100 * 2 ** (map.getZoom() - fitZoom))}%`;
    $('zoomIn').disabled = map.getZoom() >= map.getMaxZoom();
    $('zoomOut').disabled = map.getZoom() <= map.getMinZoom();
  }
  function home() {
    selected = null;
    updateSelection();
    map.fitBounds(bounds, {paddingTopLeft: [32, 46], paddingBottomRight: [32, 100], animate: initialized});
    initialized = true;
    zoomReadout();
  }
  function updateSelection() {
    $('selectedName').textContent = selected || 'Explore o mapa';
    $('selectedHint').hidden = Boolean(selected);
    $('selectedTotal').textContent = selected ? number(safeValue(selected)) : '—';
    $('selectedShare').textContent = selected ? `${percent(share(safeValue(selected)))} dos pedidos do período` : 'Selecione um bairro para ver os detalhes';
    $('clearSelection').hidden = !selected;
    for (const [name, layer] of layers) layer.setStyle(layerStyle(name));
    if (selected) layers.get(selected)?.bringToFront();
    document.querySelectorAll('.ranking-item').forEach(button => {
      const active = button.dataset.bairro === selected;
      button.classList.toggle('is-selected', active);
      button.setAttribute('aria-pressed', String(active));
    });
  }
  function select(name, focus) {
    const layer = layers.get(name);
    if (!layer) return;
    selected = name;
    updateSelection();
    if (focus) map.fitBounds(layer.getBounds(), {padding: [52, 70], maxZoom: 15, animate: true});
  }
  function renderRanking() {
    const q = normalize($('bairroSearch').value);
    const fragment = document.createDocumentFragment();
    const ranking = [...layers.keys()].map(bairro => ({bairro, total: safeValue(bairro)})).sort((a, b) => b.total - a.total || a.bairro.localeCompare(b.bairro, 'pt-BR'));
    for (const item of ranking.filter(item => normalize(item.bairro).includes(q))) {
      const button = document.createElement('button'); button.type = 'button'; button.className = 'ranking-item'; button.dataset.bairro = item.bairro;
      const main = document.createElement('span'); main.className = 'ranking-main';
      const name = document.createElement('span'); name.className = 'ranking-name'; name.textContent = item.bairro;
      const track = document.createElement('span'); track.className = 'ranking-bar';
      const bar = document.createElement('i'); bar.style.width = `${data.max ? item.total / data.max * 100 : 0}%`; track.append(bar);
      main.append(name, track);
      const values = document.createElement('span'); values.className = 'ranking-values';
      const pct = document.createElement('strong'); pct.textContent = percent(share(item.total));
      const count = document.createElement('small'); count.textContent = `${number(item.total)} ${item.total === 1 ? 'pedido' : 'pedidos'}`;
      values.append(pct, count); button.append(main, values);
      button.addEventListener('click', () => select(item.bairro, true)); fragment.append(button);
    }
    $('searchEmpty').hidden = Boolean(fragment.childElementCount);
    $('rankingList').replaceChildren(fragment);
    updateSelection();
  }
  function applyData(next) {
    data = next;
    $('mapTotal').querySelector('strong').textContent = number(data.total);
    $('mapUpdated').textContent = data.total === 0 ? 'Nenhum pedido neste período' : `Atualizado às ${data.atualizadoEm || '—'}`;
    $('legendMax').textContent = percent(share(data.max));
    $('legendMid').textContent = percent(share(data.max) / 2);
    $('unmappedNotice').hidden = !data.semBairro;
    $('unmappedNotice').textContent = `${number(data.semBairro)} ${data.semBairro === 1 ? 'pedido sem bairro identificável' : 'pedidos sem bairro identificável'} — incluídos no total, fora do mapa.`;
    for (const [name, layer] of layers) layer.setTooltipContent(tooltip(name));
    renderRanking();
    window.parent.postMessage({type: 'ecoagenda:map-update', total: Number(data.total)}, window.location.origin);
  }
  async function refresh() {
    if (busy || document.hidden) return;
    busy = true;
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 10000);
    try {
      const params = new URLSearchParams({dados: '1', mes: cfg.mes, ano: cfg.ano, _: Date.now()});
      const response = await fetch(`mapa_pinhais.php?${params}`, {cache: 'no-store', headers: {Accept: 'application/json'}, signal: controller.signal});
      if (!response.ok) throw new Error('Resposta indisponível');
      const next = await response.json();
      if (!next || typeof next.dados !== 'object' || next.dados === null || !Number.isFinite(next.total) || !Number.isFinite(next.max)) throw new Error('Dados inválidos');
      applyData(next);
    } catch {
      $('mapUpdated').textContent = 'Atualização indisponível · últimos dados mantidos';
    } finally { clearTimeout(timeout); busy = false; }
  }
  $('bairroSearch').addEventListener('input', renderRanking);
  $('bairroSearch').addEventListener('keydown', event => {
    if (event.key === 'Enter') { event.preventDefault(); const first = $('rankingList').querySelector('button'); if (first) select(first.dataset.bairro, true); }
    if (event.key === 'Escape') { $('bairroSearch').value = ''; renderRanking(); home(); }
  });
  $('zoomIn').addEventListener('click', () => map.zoomIn(0.5));
  $('zoomOut').addEventListener('click', () => map.zoomOut(0.5));
  $('zoomHome').addEventListener('click', home);
  $('clearSelection').addEventListener('click', home);
  map.on('zoomend resize', zoomReadout);
  // Um único observer e um único conjunto de listeners, mesmo após redimensionar
  // o iframe ou abrir a seção inicialmente escondida do dashboard.
  const observer = new ResizeObserver(() => {
    cancelAnimationFrame(resizeFrame);
    resizeFrame = requestAnimationFrame(() => {
      if (!canvas.clientWidth || !canvas.clientHeight) return;
      map.invalidateSize({pan: false});
      if (!initialized) home();
      else zoomReadout();
    });
  });
  observer.observe(canvas);
  if (canvas.clientWidth && canvas.clientHeight) home();
  applyData(data);
  loadGeography();
  const interval = setInterval(refresh, 60000);
  document.addEventListener('visibilitychange', () => { if (!document.hidden) refresh(); });
  window.addEventListener('pagehide', () => { clearInterval(interval); observer.disconnect(); }, {once: true});
})();
