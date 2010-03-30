
package Plano;
use Cenario;
use strict;

sub new {
    my $class = shift;
    bless $_[0], $class;
}

sub clone {
    bless { %{$_[0]} }, 'Plano'
}


sub set { 
    my ($self, $key, $v) = @_;
    $self->{$key} = $v;
}

sub _execute {
    my @fases = @_;
    for my $f ( 0 .. $#fases ) {
        if ( ref( $fases[$f] ) eq 'ARRAY' ) {
            my @todo = @fases;
            my @iteracoes = ();
            for my $x ( @{ $fases[$f] } ) {
                $todo[$f] = $x;
                push @iteracoes, _execute( @todo );
            }
            return @iteracoes;
        }
    }

    $_ = $_->clone for @fases;
    for my $f ( 1 .. $#fases ) {
        $fases[$f]{anterior} = $fases[$f-1];
    }
    return $fases[-1]->run;
}

sub run {
    my ($self) = @_;
    _execute( @{$self} );
}

1;

