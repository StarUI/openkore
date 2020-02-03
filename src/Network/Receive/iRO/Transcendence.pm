#########################################################################
#  OpenKore - Network subsystem
#  Copyright (c) 2006 OpenKore Team
#
#  This software is open source, licensed under the GNU General Public
#  License, version 2.
#  Basically, this means that you're allowed to modify and distribute
#  this software. However, if you distribute modified versions, you MUST
#  also distribute the source code.
#  See http://www.gnu.org/licenses/gpl.html for the full license.
#########################################################################
# Servertype overview: http://wiki.openkore.com/index.php/ServerType
package Network::Receive::iRO::Transcendence;

use strict;
use base qw(Network::Receive::iRO);

sub new {
	my ($class) = @_;
	my $self = $class->SUPER::new(@_);
	
	my %packets = (
		'082D' => ['received_characters_info', 'v C x2 C2 x20', [qw(len total_slot premium_start_slot premium_end_slot)]],
		'009D' => ['item_exists', 'a4 V C v3 C2', [qw(ID nameID identified x y amount subx suby)]],
		'009E' => ['item_appeared', 'a4 V C v2 C2 v', [qw(ID nameID identified x y subx suby amount)]],
		'01C8' => ['item_used', 'a2 V a4 v C', [qw(ID itemID actorID remaining success)]],
		'09FD' => ['actor_moved', 'v C a4 a4 v3 V v2 V2 v V v6 a4 a2 v V C2 a6 C2 v2 V2 C v Z*', [qw(len object_type ID charID walk_speed opt1 opt2 option type hair_style weapon shield lowhead tick tophead midhead hair_color clothes_color head_dir costume guildID emblemID manner opt3 stance sex coords xSize ySize lv font maxHP HP isBoss opt4 name)]],
		'09FE' => ['actor_connected', 'v C a4 a4 v3 V v2 V2 v7 a4 a2 v V C2 a3 C3 v2 V2 C v Z*', [qw(len object_type ID charID walk_speed opt1 opt2 option type hair_style weapon shield lowhead tophead midhead hair_color clothes_color head_dir costume guildID emblemID manner opt3 stance sex coords xSize ySize lv font maxHP HP isBoss opt4 name)]],
		'09FF' => ['actor_exists', 'v C a4 a4 v3 V v2 V2 v7 a4 a2 v V C2 a3 C3 v2 V2 C v Z*', [qw(len object_type ID charID walk_speed opt1 opt2 option type hair_style weapon shield lowhead tophead midhead hair_color clothes_color head_dir costume guildID emblemID manner opt3 stance sex coords xSize ySize lv font maxHP HP isBoss opt4 name)]],
		'0A37' => ['inventory_item_added', 'a2 v V C3 a16 V C2 a4 v a25 C v', [qw(ID amount nameID identified broken upgrade cards type_equip type fail expire unknown options favorite viewID)]],		
	);

	$self->{packet_list}{$_} = $packets{$_} for keys %packets;

	my %handlers = qw(
		received_characters 099D
		received_characters_info 082D
		sync_received_characters 09A0
		account_server_info 0AC4
	);

	$self->{packet_lut}{$_} = $handlers{$_} for keys %handlers;

	return $self;
}


1;