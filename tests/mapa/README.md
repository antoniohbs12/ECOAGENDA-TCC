# Regressão dos mapas

Estes testes usam o SQL de outubro/2026 enviado pelo autor: 6 pedidos e 3 coletas finalizadas. Execute somente em uma instância de desenvolvimento com esse conjunto de dados. A API deve ter localizado os endereços antes de `test_interface.py`; no material enviado, os três resultados são aproximados na rua.

Dependência: Python e Playwright (`python -m pip install playwright`, `python -m playwright install chromium`). Configure `ECOAGENDA_TEST_BASE_URL` com a URL da pasta do administrador e `ECOAGENDA_TEST_SESSION` com o identificador de uma sessão administrativa de teste existente. Não salve cookies ou credenciais no repositório. `ECOAGENDA_TEST_CHROMIUM` permite usar um executável Chromium já instalado.

Execute `python tests/mapa/test_interface.py` e `python tests/mapa/test_falhas.py`.

Os testes verificam as duas seções, scroll, busca, seleção, redimensionamento, mês vazio, autenticação, CSRF e falhas sem inventar posições. Capturas de tela são gravadas na pasta temporária da máquina. Os testes não criam contas, não modificam o banco e não incluem credenciais de teste predefinidas.
