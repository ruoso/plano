
use Dinheiro;
use Porcentagem;
use Quantidade;
use Formula;
use Cenario;
use Plano;
use strict;

my $i = Plano->new
  ([
    Cenario->new
    ({ nome => 'DEFINICAO INICIAL',
       duracao => 1,
       '$CAPITAL_DISPONIVEL' => Dinheiro->new( 250_000 )
     }),
    [ Cenario->new
      ({ 'duracao' => 4,
         'nome' => 'APLICACAO POR 4 ANOS',
         '%TAXA_RETORNO_AO_ANO' => Porcentagem->new( 9 ),
         '$JUROS_RECEBIDOS' => Formula->new(sub { Dinheiro->new
                                                    ( $_[0]->anterior(1,'$CAPITAL_DISPONIVEL') *
                                                      $_[0]->get('%TAXA_RETORNO_AO_ANO') ) }),
         '$CAPITAL_DISPONIVEL' => Formula->new(sub { Dinheiro->new
                                                       ( $_[0]->anterior(1,'$CAPITAL_DISPONIVEL') +
                                                         $_[0]->get('$JUROS_RECEBIDOS') ) }),
       }),
      Cenario->new
      ({ 'duracao' => 4,
         'nome'    => 'PROJETO A',
         '$DESPESAS_ADMINISTRATIVAS' => Dinheiro->new( 15_000 ),
         '$DESPESAS_GERAIS' => Dinheiro->new( 18_000 ),
         '$DESPESAS_FINANCEIRAS' => Dinheiro->new( 1_200 ),
         '$INVESTIMENTO_EM_ATIVOS' => [ Dinheiro->new( 70_500 ),
                                        Dinheiro->new( 0 ) ],
         '$VALOR_DEPRECIACAO' => Dinheiro->new( 23_500 ),
         '$INVESTIMENTO_CAPITAL_DE_GIRO' => [ Dinheiro->new( 10_000 ),
                                              Dinheiro->new( 0 ) ],
         '%IMPOSTO_SOBRE_RECEITA' => Porcentagem->new( 11 ),
         '%CUSTO_DOS_PRODUTOS_VENDIDOS' => Porcentagem->new( 25 ),
         '%CUSTOS_COMERCIAIS' => Porcentagem->new( 5 ),
         '%CRESCIMENTO_RECEITA' => Porcentagem->new( 12 ),
         '%IMPOSTO_DE_RENDA' => Porcentagem->new( 27 ),
         '$RECEITA_ANUAL' => [ Dinheiro->new( 235_000 ),
                               Formula->new(sub { Dinheiro->new
                                                    ( $_[0]->anterior(1,'$RECEITA_ANUAL') +
                                                      ( $_[0]->anterior(1,'$RECEITA_ANUAL') *
                                                        $_[0]->get('%CRESCIMENTO_RECEITA') ))
                                                }),
                             ],
         '$RECEITA_LIQUIDA' => Formula->new(sub { Dinheiro->new
                                                    ( $_[0]->get('$RECEITA_ANUAL') -
                                                      $_[0]->get('$RECEITA_ANUAL') *
                                                      $_[0]->get('%IMPOSTO_SOBRE_RECEITA') ) }),
         '$LUCRO_OPERACIONAL_BRUTO' => Formula->new(sub { Dinheiro->new
                                                            ( $_[0]->get('$RECEITA_LIQUIDA') -
                                                              $_[0]->get('$RECEITA_ANUAL') *
                                                              $_[0]->get('%CUSTO_DOS_PRODUTOS_VENDIDOS') ) }),
         '$LUCRO_OPERACIONAL' => Formula->new(sub { Dinheiro->new
                                                      ( $_[0]->get('$LUCRO_OPERACIONAL_BRUTO') -
                                                        $_[0]->get('$DESPESAS_ADMINISTRATIVAS') -
                                                        $_[0]->get('$DESPESAS_GERAIS') -
                                                        ( $_[0]->get('%CUSTOS_COMERCIAIS') *
                                                          $_[0]->get('$RECEITA_ANUAL') ) ) }),
         '$LUCRO_ANTES_DE_JUROS_E_IR' => Formula->new(sub { Dinheiro->new
                                                              ( $_[0]->get('$LUCRO_OPERACIONAL') -
                                                                $_[0]->get('$VALOR_DEPRECIACAO') ) }),
         '$IR_ANUAL' => Formula->new(sub { Dinheiro->new
                                             ( $_[0]->get('$LUCRO_ANTES_DE_JUROS_E_IR') *
                                               $_[0]->get('%IMPOSTO_DE_RENDA') ) }),
         '$LUCRO_LIQUIDO' => Formula->new(sub { Dinheiro->new
                                                  ( $_[0]->get('$LUCRO_ANTES_DE_JUROS_E_IR') -
                                                    $_[0]->get('$IR_ANUAL') ) }),
         '$ALTERACAO_DISPONIBILIDADE' => Formula->new(sub { Dinheiro->new
                                                              ( $_[0]->get('$LUCRO_LIQUIDO') -
                                                                $_[0]->get('$INVESTIMENTO_CAPITAL_DE_GIRO') -
                                                                $_[0]->get('$INVESTIMENTO_EM_ATIVOS') ) }),
         '$CAPITAL_DISPONIVEL' => Formula->new(sub { Dinheiro->new
                                                       ( $_[0]->anterior(1,'$CAPITAL_DISPONIVEL') +
                                                         $_[0]->get('$ALTERACAO_DISPONIBILIDADE') ) })
       }),
    ]
   ]);

my @cenarios = $i->run;
$_->export_csv for @cenarios;

