
package Iteracao;

sub new {
    my $class = shift;
    bless $_[0], $class;
}

sub clone {
    bless { %{$_[0]} }, 'Iteracao'
}

sub get {
    my ($self, $tag ) = @_;
    my $v = $self->{$tag};
    if ( ref( $v ) eq 'ARRAY' ) {
        $v = $v->[0];
    }
    if ( ref( $v ) eq 'Formula' ) {
        return ${$v}->( $self );
    }
    return $v;
}

sub set {
    my ($self, $tag, $v) = @_;
    $self->{$tag} = $v;
}

sub anterior {
    my ($self, $n, $tag) = @_;
    #print "looking anterior '$tag' $n ",$self->{iteracao},"\n";
    if ( exists $self->{anterior} ) {
        #local $::Context = $self->{anterior};
        #print "  looking $n ", $::Context->{iteracao}, "\n";
        #print "    isa ", ref($::Context->anterior( $n - 1, $tag )), "\n";
        if ( $n > 1 ) {
            return $self->{anterior}->anterior( $n - 1, $tag );
        }
        return $self->{anterior}->get( $tag );
    }
    #print "nao ha iteracao anterior\n";
    return $self->get( $tag );
}

1;
