<?php
declare(strict_types=1);

session_start();
require_once "../../config.php";

if (
    !isset($_SESSION["email"]) ||
    !isset($_SESSION["perfil"]) ||
    $_SESSION["perfil"] !== "administrador"
) {
    http_response_code(403);
    exit("Acesso negado.");
}

session_write_close();

$mes = isset($_GET["mes"]) ? (int)$_GET["mes"] : (int)date("n");
$ano = isset($_GET["ano"]) ? (int)$_GET["ano"] : (int)date("Y");
if ($mes < 1 || $mes > 12) $mes = (int)date("n");
if ($ano < 2020 || $ano > 2100) $ano = (int)date("Y");

$meses = [
    1 => "Janeiro", 2 => "Fevereiro", 3 => "Março", 4 => "Abril",
    5 => "Maio", 6 => "Junho", 7 => "Julho", 8 => "Agosto",
    9 => "Setembro", 10 => "Outubro", 11 => "Novembro", 12 => "Dezembro"
];

$bairros = [
    "Alphaville Graciosa",
    "Alto Tarumã",
    "Atuba",
    "Centro",
    "Emiliano Perneta",
    "Estância Pinhais",
    "Jardim Amélia",
    "Jardim Cláudia",
    "Jardim Karla",
    "Maria Antonieta",
    "Parque das Águas",
    "Parque das Nascentes",
    "Pineville",
    "Vargem Grande",
    "Weissópolis"
];

function normalizarMapa(string $valor): string
{
    $valor = trim(mb_strtolower($valor, "UTF-8"));

    // Compatibilidade com registros antigos do EcoAgenda.
    $valor = str_replace("jardim das nascentes", "parque das nascentes", $valor);

    $ascii = @iconv("UTF-8", "ASCII//TRANSLIT//IGNORE", $valor);
    if ($ascii !== false) {
        $valor = strtolower($ascii);
    }

    $valor = preg_replace('/[^a-z0-9]+/', ' ', $valor) ?? $valor;
    return trim(preg_replace('/\s+/', ' ', $valor) ?? $valor);
}

function buscarDadosMapa(mysqli $conn, int $mes, int $ano, array $bairros): array
{
    $inicio = sprintf("%04d-%02d-01 00:00:00", $ano, $mes);
    $fim = date("Y-m-d H:i:s", strtotime($inicio . " +1 month"));

    $dados = array_fill_keys($bairros, 0);

    // Um pedido conta uma vez. Vínculos conflitantes ficam fora do mapa,
    // em vez de atribuir a mesma coleta a dois bairros.
    $sql = "SELECT a.id, e.bairro
        FROM agendamento a
        LEFT JOIN agendamento_morador_endereco ame
            ON ame.agendamento_id = a.id AND ame.morador_email = a.morador_email
        LEFT JOIN endereco e ON e.id = ame.endereco_id AND e.email = ame.morador_email
        WHERE a.data_pedido >= ? AND a.data_pedido < ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ss", $inicio, $fim);
    $stmt->execute();
    $result = $stmt->get_result();
    $canonicos = [];
    foreach ($bairros as $bairro) $canonicos[normalizarMapa($bairro)] = $bairro;
    $pedidos = [];
    while ($row = $result->fetch_assoc()) {
        $id = (int)$row["id"];
        $chave = normalizarMapa((string)($row["bairro"] ?? ""));
        $pedidos[$id][$canonicos[$chave] ?? "__sem_bairro"] = true;
    }
    $stmt->close();
    $semBairro = 0;
    foreach ($pedidos as $locais) {
        if (count($locais) === 1 && !isset($locais["__sem_bairro"])) {
            $dados[array_key_first($locais)]++;
        } else {
            $semBairro++;
        }
    }
    $total = count($pedidos);
    $max = 0;

    foreach ($dados as $valor) {
        $max = max($max, (int)$valor);
    }

    $ranking = [];
    foreach ($dados as $bairro => $valor) {
        $ranking[] = [
            "bairro" => $bairro,
            "total" => (int)$valor
        ];
    }

    usort($ranking, static function (array $a, array $b): int {
        if ($a["total"] === $b["total"]) {
            return strcasecmp($a["bairro"], $b["bairro"]);
        }
        return $b["total"] <=> $a["total"];
    });

    $mesesMapa = [
        1 => "Janeiro", 2 => "Fevereiro", 3 => "Março", 4 => "Abril",
        5 => "Maio", 6 => "Junho", 7 => "Julho", 8 => "Agosto",
        9 => "Setembro", 10 => "Outubro", 11 => "Novembro", 12 => "Dezembro"
    ];

    return [
        "mes" => $mes,
        "ano" => $ano,
        "mesNome" => $mesesMapa[$mes] ?? "",
        "dados" => $dados,
        "ranking" => $ranking,
        "total" => $total,
        "max" => $max,
        "semBairro" => $semBairro,
        "totalMapeado" => array_sum($dados),
        "atualizadoEm" => date("H:i:s")
    ];
}

if (isset($_GET["dados"]) && $_GET["dados"] === "1") {
    header("Content-Type: application/json; charset=UTF-8");
    header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
    echo json_encode(
        buscarDadosMapa($conn, $mes, $ano, $bairros),
        JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES
    );
    exit;
}

/* GeoJSON carregado pelo próprio PHP e entregue ao D3 no HTML.
 * Isso evita que o navegador tente abrir um arquivo .geojson por uma rota
 * que possa devolver uma página HTML/erro do servidor.
 */
$geoJsonPath = __DIR__ . DIRECTORY_SEPARATOR . "pinhais_bairros_wgs84.geojson";
$geoJsonRaw = is_file($geoJsonPath) ? file_get_contents($geoJsonPath) : false;
$geoJsonData = is_string($geoJsonRaw) ? json_decode($geoJsonRaw, true) : null;
if (!is_array($geoJsonData) || ($geoJsonData["type"] ?? null) !== "FeatureCollection") {
    $geoJsonData = ["type" => "FeatureCollection", "features" => []];
}
$geoJsonInline = json_encode(
    $geoJsonData,
    JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_INVALID_UTF8_SUBSTITUTE | JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT
);
if ($geoJsonInline === false) {
    $geoJsonInline = '{"type":"FeatureCollection","features":[]}';
}

// Dados iniciais dos pedidos já são enviados no HTML para que o mapa
// apareça sem depender de uma chamada AJAX no primeiro carregamento.
$dadosMapaInicial = buscarDadosMapa($conn, $mes, $ano, $bairros);
$dadosMapaInicialInline = json_encode(
    $dadosMapaInicial,
    JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_INVALID_UTF8_SUBSTITUTE | JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT
);
if ($dadosMapaInicialInline === false) {
    $dadosMapaInicialInline = '{"mes":' . (int)$mes . ',"ano":' . (int)$ano . ',"dados":{},"ranking":[],"total":0,"max":0,"atualizadoEm":""}';
}

?>
<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Mapa de coletas — EcoAgenda</title>
<link rel="stylesheet" href="vendor/leaflet/leaflet.css">
<link rel="stylesheet" href="mapa_pinhais.css?v=20261008-1">
<script defer src="vendor/leaflet/leaflet.js"></script>
<script defer src="mapa_pinhais.js?v=20261008-1"></script>
</head>
<body>
<div class="map-app">
    <header class="map-top">
        <div class="map-heading">
            <span class="map-eyebrow">DISTRIBUIÇÃO TERRITORIAL</span>
            <h2>Mapa de coletas em Pinhais</h2>
            <p><?= htmlspecialchars($meses[$mes], ENT_QUOTES, "UTF-8") ?> de <?= $ano ?> · pedidos de coleta por bairro</p>
        </div>
        <div class="map-total" id="mapTotal"><strong><?= (int)$dadosMapaInicial['total'] ?></strong><span>pedidos no período</span><small id="mapUpdated" role="status">Dados do período</small></div>
    </header>
    <div class="map-toolbar">
        <label class="map-search"><span class="sr-only">Pesquisar bairro</span><span aria-hidden="true">⌕</span><input type="search" id="bairroSearch" placeholder="Buscar bairro de Pinhais" autocomplete="off" aria-controls="rankingList"></label>
        <div class="map-controls" aria-label="Controles do mapa">
            <button type="button" id="zoomOut" aria-label="Diminuir zoom" title="Diminuir zoom">−</button>
            <output id="zoomLevel" aria-label="Nível de zoom">100%</output>
            <button type="button" id="zoomIn" aria-label="Aumentar zoom" title="Aumentar zoom">+</button>
            <button type="button" id="zoomHome" class="map-home" title="Ver todos os bairros">↺ <span>Pinhais</span></button>
        </div>
    </div>
    <main class="map-workspace">
        <section class="map-panel" aria-label="Mapa dos bairros">
            <div id="mapCanvas" tabindex="0" aria-label="Mapa interativo de Pinhais. Use os botões para ampliar e a lista para selecionar um bairro."></div>
            <div class="map-caption"><span class="map-dot"></span> Limites dos bairros de Pinhais</div>
            <div id="mapState" class="map-state" role="status" hidden></div>
            <div class="map-legend"><span>Participação nos pedidos do período</span><div class="legend-gradient"></div><div class="legend-ticks"><span>0%</span><span id="legendMid">0%</span><span id="legendMax">0%</span></div></div>
            <p id="tileNotice" class="tile-notice" role="status" hidden>Fundo cartográfico indisponível. Os bairros e os pedidos continuam disponíveis.</p>
        </section>
        <aside class="map-sidebar">
            <div class="map-side-head"><span class="map-side-label">BAIRRO SELECIONADO</span><div class="map-selected"><h3 id="selectedName">Explore o mapa</h3><p id="selectedHint">Clique em um bairro ou use a busca.</p><div class="selected-line"><strong id="selectedTotal">—</strong><span>pedidos no período</span></div><span id="selectedShare" class="selected-share">—</span><button id="clearSelection" type="button" hidden>Limpar seleção ×</button></div></div>
            <div class="map-ranking"><div class="ranking-heading"><h3>Onde mais há pedidos</h3><span>Participação no período selecionado</span></div><div id="rankingList"></div><p id="searchEmpty" hidden>Nenhum bairro encontrado. Tente outro nome.</p></div>
            <div class="map-footer"><p id="unmappedNotice" hidden></p><span>Limites: GeoPinhais · base 2012</span><span>Pedidos: EcoAgenda · atualização a cada minuto</span></div>
        </aside>
    </main>
</div>
<script>window.EcoAgendaMapa = {geojson: <?= $geoJsonInline ?>, data: <?= $dadosMapaInicialInline ?>, mes: <?= $mes ?>, ano: <?= $ano ?>};</script>
</body>
</html>
