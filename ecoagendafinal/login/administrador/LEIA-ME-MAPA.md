# Mapa de coletas de Pinhais

Este diretório contém o módulo atualizado para aplicar ao site do RAR enviado em 08/10/2026. Os demais arquivos do site ainda não foram importados para este diretório do repositório. Não substitua a pasta inteira do projeto: copie os arquivos deste módulo para a pasta `login/administrador` existente, mantendo `administrador.php`, `config.php` e os demais arquivos.

O `administrador.php` atual já incorpora `mapa_pinhais.php` em um iframe e recebe o total por `postMessage`. Não precisa mudar para aplicar este pacote. Não há migração de banco.

## Arquivos

- `mapa_pinhais.php`: controle de acesso de administrador, consulta ao banco e HTML do módulo.
- `mapa_pinhais.js`: Leaflet, busca, seleção, zoom, ranking e atualização dos pedidos.
- `mapa_pinhais.css`: aparência e comportamento responsivo, sem estilos inline concorrentes.
- `pinhais_bairros_wgs84.geojson`: os 15 bairros do arquivo enviado, preservados integralmente.
- `pinhais_base.geojson`: ruas/estradas, áreas verdes, rios e lagos locais, sem nomes de ruas.
- `vendor/leaflet`: distribuição Leaflet 1.9.4 e licença; nenhuma CDN é necessária em execução.

## Aplicação no XAMPP

1. Faça backup dos três arquivos `mapa_pinhais.*` atuais.
2. Copie o conteúdo deste diretório para `ecoagendafinal/login/administrador`, mesclando as pastas.
3. Use o banco SQL atual enviado pelo autor e a conexão MySQLi já configurada no site. PHP precisa de `mysqli`, `mbstring` e `iconv`.
4. Entre com o perfil Administrador e abra o dashboard. O mapa usa o mês/ano passados pelo iframe existente.
5. Faça recarga forçada do navegador se houver cache da versão antiga.

A base local ocupa aproximadamente 2,4 MB antes da compressão HTTP. A compactação gzip no Apache reduz a transferência; ela é opcional. Todos os recursos gráficos do mapa são locais. Atualizações dos pedidos consultam apenas o próprio site, a cada 60 segundos. A base de ruas é um snapshot; não recebe atualizações de ruas automaticamente.

## Dados e cartografia

- Os 15 polígonos foram comparados com `BAIRROS.shp` do RAR: as geometrias correspondem exatamente. Todos são válidos.
- O arquivo `.prj` identifica SIRGAS 2000 / UTM 22S, EPSG:31982. A reprojeção para WGS84 foi conferida contra `pinhais_bairros_wgs84.geojson`: diferença máxima de 3,6 × 10⁻¹⁵ graus, limitada ao arredondamento numérico.
- A base de bairros identifica Prefeitura Municipal de Pinhais / GeoPinhais e **ano de referência 2012**. Isso confirma fidelidade ao material enviado, sem certificar mudanças municipais posteriores.
- A base de ruas/hidrografia deriva dos tiles vetoriais públicos CARTO/OpenStreetMap obtidos em 08/10/2026, nível 14. Foram mantidas as camadas `landcover`, `landuse`, `park`, `water`, `waterway` e `transportation`, sem símbolos ou nomes de ruas. O recorte utiliza a união dos bairros fornecidos. A atribuição permanece no mapa; respeite a licença OpenStreetMap ODbL e a atribuição CARTO ao redistribuir os dados.
- Fonte dos tiles: `https://basemaps.cartocdn.com/vectortiles/carto.streets/v1/{z}/{x}/{y}.mvt`. O provedor de raster experimentado devolvia imagens com exigência de chave, por isso não é utilizado.
- O mapa exibe **pedidos criados no período**, considerando `agendamento.data_pedido`, independentemente do status. Não representa exclusivamente coletas já concluídas.
- Cada pedido conta uma vez. Sem bairro reconhecido ou com endereços vinculados a bairros conflitantes, ele permanece no total e aparece no aviso de pedidos fora do mapa. `Jardim das Nascentes` é normalizado para `Parque das Nascentes`.
- Percentuais consideram o total de pedidos do período. A cor representa a intensidade relativa ao bairro com mais pedidos; bairros com zero permanecem visíveis.

## Validação realizada

- PHP: sintaxe e endpoint JSON verificados; acesso sem sessão recebe HTTP 403.
- SQL enviado: outubro/2026 retorna 6 pedidos, Jardim Amélia 5 (83,3%) e Jardim Karla 1 (16,7%). Bairro desconhecido e alias histórico testados em transações revertidas.
- Chromium: 15 bairros e 15 entradas de ranking; busca sem acentos, seleção por Enter/clique, zoom, retorno à visão geral, busca vazia, mês sem pedidos e tamanhos de 390 a 1400 px.
- Funcionamento dentro do iframe original do administrador confirmado, incluindo sincronização do total com o dashboard.
- Falha da base local mantém os bairros e o ranking disponíveis. Falha na atualização JSON mantém os últimos dados e informa indisponibilidade.
- A versão final não fez requisições externas no navegador e não apresentou erros JavaScript.

O banco deste ambiente de validação é MariaDB 11.8 com o SQL enviado, cuja origem também informa MariaDB. O código mantém MySQLi e SQL compatível com MySQL; não foi executada uma validação separada em um servidor Oracle MySQL.
