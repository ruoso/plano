
package Cenario;
use Iteracao;
use strict;

sub new {
    my $class = shift;
    bless $_[0], $class;
}

sub clone {
    bless { %{$_[0]} }, 'Cenario'
}


sub set { 
    my ($self, $key, $v) = @_;
    $self->{$key} = $v;
}

sub run {
    my ($self) = @_;
    my $i;
    if ( $self->{anterior} ) {
        my $proto = $self->{anterior};
        my $ant = $proto;
        if ( $proto->{duracao} < 1 ) {
            $ant = $proto->{anterior};
            if ( $ant ) {
                $ant = $ant->run;
                $proto = { %{$ant}, %{$proto} };
            }
        }
        else {
            $ant = $ant->run
        }
        $i = Iteracao->new( {
                %{$proto},
                %{$self},
            } );
        $i->{anterior} = $ant;
        $i->{iteracao} = 0;
    }
    else {
        # primeira iteracao
        $i = Iteracao->new( {%{$self}} );
        $i->{anterior} = undef;
        $i->{iteracao} = 0;
    }
    while (  $i->{duracao}
             && $i->{iteracao} < $i->{duracao} ) {
        last if ( $i->{iteracao} + 1 ) >= $i->{duracao};

        my $prev = $i->clone;
        $i->{iteracao}++;
        $i->{anterior} = $prev;
        for my $k ( keys %$i ) {
            if ( ref( $i->{$k} ) eq 'ARRAY' ) {
                my @a = @{ $i->{$k} };
                $i->{$k} = [ splice( @a, 1 ) ]
                  if @a > 1;
            }
        }
    }
    return $i;
}

1;

