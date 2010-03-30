package Formula;

sub new {
    my ($class, $v) = @_;
    bless \$v, $class;
}

#use overload 
#    '0+' => sub { ${$_[0]}->() },
#;

1;

