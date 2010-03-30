package Porcentagem;

sub new {
    my ($class, $v) = @_;
    bless \$v, $class;
}

use overload 
    '0+' => sub { ${$_[0]} },
    fallback => 1,
;

1;

__END__
class Porcentagem;

use Dinheiro;

has $.valor;

multi *prefix:<+> (Porcentagem $v) { $v.valor }
multi *prefix:<~> (Porcentagem $v) { $v.valor ~ "%" }
multi *infix:<*>  (Dinheiro $v, Porcentagem $u) { 
    my $d = $v.valor;
    my $x = $d * ($u.valor);
    Dinheiro.new( valor => ($x / 100.0) ) 
}

