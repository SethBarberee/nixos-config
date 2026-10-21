# Den schema — common to all hosts.
{ inputs, ... }:
{
  # Schema: users get home-manager as a class
  den.schema.user.classes = [ "homeManager" ];
}
