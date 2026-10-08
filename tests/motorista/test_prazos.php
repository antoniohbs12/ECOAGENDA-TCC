<?php
require $argv[1] ?? __DIR__ . '/../../ecoagendafinal/login/motorista/motorista_prazos.php';
function verificar($condicao, $mensagem) { if (!$condicao) throw new RuntimeException($mensagem); }
foreach (['2026-10-02'=>'2026-10-09', '2026-10-03'=>'2026-10-09', '2026-10-04'=>'2026-10-09', '2026-10-05'=>'2026-10-12'] as $base=>$limite) {
    $p=prazoMotorista(['status'=>'Encaminhado','data_pedido'=>$base], '2026-10-08');
    verificar($p['limite']===$limite, 'Contagem de dias úteis: '.$base);
}
foreach (['2026-10-08'=>'valido','2026-10-09'=>'hoje','2026-10-10'=>'vencido'] as $hoje=>$classe) {
    $p=prazoMotorista(['status'=>'Em andamento','data_pedido'=>'2026-10-02','data_inicio'=>'2026-10-08'], $hoje);
    verificar($p['classe']===$classe && $p['limite']==='2026-10-09', 'Prazo não muda ao iniciar coleta');
}
foreach (['Concluído','Concluido','Suspenso','Cancelado'] as $status) {
    $p=prazoMotorista(['status'=>$status,'data_pedido'=>'2026-10-02'],'2026-10-20');
    verificar(!$p['ativo'] && $p['classe']==='encerrado', 'Histórico não aparece como vencido');
}
$p=prazoMotorista(['status'=>'A caminho','data_pedido'=>'2026-02-31'],'2026-10-08');
verificar($p['limite']==='' && $p['classe']==='sem-prazo', 'Não inventar prazo para data inválida');
echo "Prazos: OK\n";
