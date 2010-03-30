
package Dinheiro;
use Data::Dumper;

sub new { 
    my ($class, $v) = @_;
    bless \$v, $class;
}

use overload
  '0+' => sub { ${$_[0]} },
  '*'  => sub { 
      die "nao pode multiplicar Dinheiro por Formula"
        if ref($_[1]) eq 'Formula';
      return Dinheiro->new( ${$_[0]} * $_[1] / 100 )
        if ref($_[1]) eq 'Porcentagem';
      return Dinheiro->new( ${$_[0]} * $_[1] )
  },
  '""'  => sub { use locale; sprintf("R\$ %.2f", ${$_[0]}) },
  fallback => 1,
  ;

#multi *prefix:<+> (Dinheiro $v) { $v.valor }
#multi *prefix:<~> (Dinheiro $v) { "€" ~ $v.valor }
#multi *infix:<+>  (Dinheiro $v, Dinheiro $u) { 
#    Dinheiro.new( valor => ($v.valor + $u.valor) ) 
#}

1;

