#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_magicbox_lock;
#include maps\mp\zombies\_zm_magicbox;



init() 
{
	
    level thread onplayerconnect();
	if (getdvar("ui_zm_mapstartlocation") != "town") return;
	box_init();
	level thread movePerkMachines();
	level thread spawnCustomObjects();
    level.perk_purchase_limit = 9;
    setdvar("r_fog", "0");
	
	player = get_players()[0];
	
	level thread teleporterplayer_begin();
	level thread teleporterplayer_back_begin();
	
	level thread roundMonitor();
}

teleporterplayer_begin()
{
	while ( level.round_number < 2 )
	{
		wait 1; 
	}
	iprintln("^5Teleporters Spawned!");
	
	teleporter_coords = (2065.44, 163.626, 89.7179);
	destination_coords = (650.641, -1070.89, 120.125);
	angles = (0, 0, 0);

	
	dotelestartondemand = spawn("script_model", teleporter_coords);
	dotelestartondemand.angles = angles;
	dotelestartondemand setModel("zombie_vending_doubletap2_on");

	
	precachemodel( "zm_collision_perks1" );
	collision = spawn( "script_model", dotelestartondemand.origin);
	collision.angles = dotelestartondemand.angles;
	collision setModel( "zm_collision_perks1" );

	
	dotelestartondemand_trigger = spawn("trigger_radius", teleporter_coords, 0, 48, 64);
	dotelestartondemand_trigger setcursorhint("HINT_NOICON");
	dotelestartondemand_trigger sethintstring("Hold ^5F ^7to ^5Teleport!");
	for(;;) { 
		dotelestartondemand_trigger waittill("trigger", player);
		if(player useButtonPressed())
		{
			
			player setorigin(destination_coords);
			
		}
		wait 0.5;
	}
}

teleporterplayer_back_begin()
{
	while ( level.round_number < 2 )
	{
		wait 1; 
	}
	
	teleporter_coords = (796.619, -1373.66, 124.657);
	destination_coords = (2267.64, 16.2823, 88.125);
	angles = (0, -180, 0);

	
	telepersonondemand = spawn("script_model", teleporter_coords);
	telepersonondemand.angles = angles;
	telepersonondemand setModel("zombie_vending_doubletap2_on");

	
	precachemodel( "zm_collision_perks1" );
	collision = spawn( "script_model", telepersonondemand.origin);
	collision.angles = telepersonondemand.angles;
	collision setModel( "zm_collision_perks1" );

	
	telepersonondemand_trigger = spawn("trigger_radius", teleporter_coords, 0, 48, 64);
	telepersonondemand_trigger setcursorhint("HINT_NOICON");
	telepersonondemand_trigger sethintstring("Hold ^5F ^7to ^5Teleport!");
	for(;;) { 
		telepersonondemand_trigger waittill("trigger", player);
		if(player useButtonPressed())
		{
			
			player setorigin(destination_coords);
		}
		wait 0.5;
	}
}

spawnCustomObjects()
{

	// Front Walls
	num = 1808.85;
	for (i = 0; i < 9; i++)
	{
		spawnObject( "p6_zm_bank_pilaster_1", (num, -125.852, 87.7527 ), ( 0, 0, 0 ) );
		num += 22;
	}
	spawnObject( "collision_wall_512x512x10_standard", (1808.85, -125.852, 87.7527 ), ( 0, 0, 0 ) ); // Invisible Collider
	spawnObject( "tag_body", (1808.85, -125.852, 87.7527 ), ( 0, 0, 0 ) ); // Invisible Collider
	// Right Walls
	num = -116.815;
	for (i = 0; i < 15; i++)
	{
		spawnObject( "p6_zm_bank_pilaster_1", (1797.07, num, 87.8905 ), ( 0, -90, 0 ) );
		num += 22;
	}
	spawnObject( "collision_wall_512x512x10_standard", (1797.07, -116.815, 87.8905 ), ( 0, 0, 0 ) ); // Invisible Collider

	// Left Walls
	num = -776.224;
	for (i = 0; i < 15; i++)
	{
		spawnObject( "p6_zm_bank_pilaster_1", (1150.97, num, 135.738 ), ( 0, 90, 0 ) );
		num -= 22;
	}
	spawnObject( "collision_wall_64x64x10_standard", (2409, -652, -25 ), ( 0, 0, 0 ) ); // Invisible Collider

	// Ceiling
	spawnObject( "p6_zm_tunnel_pillar_1", (2240, -590, 163 ), ( 90, 90, 90 ) );
	
	spawnObject( "collision_wall_64x64x10_standard", (2364.75, 374.82, -24.8603 ), ( 0, -90, 0 ) ); // Invisible Collider
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// split town map
	
	
	num = 1147; // Back wall on jump
	for (i = 0; i < 7; i++)
	{
		spawnObject( "p6_zm_bank_pilaster_1", (num, -776.352, 113.91 ), ( 0, 180, 0 ) );
		spawnObject( "collision_wall_512x512x10_standard", (num, -776.352, 113.91 ), ( 0, 180, 0 ) ); // Invisible Collider back
		num += 22;
	}
	
	num = 1147; // Back wall on jump
	for (i = 0; i < 7; i++)
	{
		spawnObject( "p6_zm_bank_pilaster_1", (num, -776.352, 113.91 ), ( 0, -180, 0 ) );
		num -= 22;
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	spawnObject( "collision_wall_64x64x10_standard", (1060.44, -1229.21, 122.129 ), ( 0, -90, 0 ) ); // Invisible Collider second jump spot
	spawnObject( "collision_wall_64x64x10_standard", (692.521, -1271.05, 117.871 ), ( 0, -90, 0 ) ); // Invisible Collider Door Blocker Left
	spawnObject( "collision_wall_64x64x10_standard", (694.08, -1207.77, 115.643 ), ( 0, -90, 0 ) ); // Invisible Collider Door Blocker Right
}

onplayerconnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onplayerspawned();
		player thread tps_unlimitedammo_machine_town();
		player iprintln("^5Map Created By: The Pit Stop");
    }
}

onplayerspawned()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
        if (getdvar("ui_zm_mapstartlocation") != "town") return;
		self teleportToSpawn();
		flag_wait("initial_blackscreen_passed");
		level.player_out_of_playable_area_monitor = false;
    }
}

teleportToSpawn()
{
    player = level.players;
	if( player[ 0] == self ) player[ 0] setorigin( (2406.51, 66.7639, 88.125 ) );
	if( player[ 1] == self ) player[ 1] setorigin( (2423.31, 373.489, -55.875) );
	if( player[ 2] == self ) player[ 2] setorigin( (1917.61, -22.3463, 88.125 ) );
	if( player[ 3] == self ) player[ 3] setorigin( (2089.44, 78.1735, 88.125 ) );
}

movePerkMachines()
{
	perk_system( "script_model", ( 2269.65, -152.347, 235.843 ), "zombie_vending_revive_on", ( -180, 180, 0 ), "revive" );
	perk_system( "script_model", ( 2344.36, -78.3471, 88.125 ), "zombie_vending_jugg_on", ( 0, -90, 0 ), "original", "mus_perks_jugganog_sting", "Jugger-Nog", 30000, "jugger_light", "specialty_armorvest" );
    perk_system( "script_model", ( 1819.64, -66.5045, 88.125 ), "zombie_vending_sleight_on", ( 0, 90, 0 ), "original", "mus_perks_speed_sting", "Speed Cola", 25000, "sleight_light", "specialty_fastreload" );
    perk_system( "script_model", ( 2345.58, 352.832, -51.6348 ), "zombie_vending_doubletap2_on", ( 0, 90, 0 ), "original", "mus_perks_doubletap_sting", "Double Tap Root Beer", 20000, "doubletap_light", "specialty_rof" );
	perk_system( "script_model", ( 2344.3, 131.645, 88.125 ), "zombie_vending_marathon_on", ( 0, -90, 0 ), "original", "mus_perks_stamin_sting", "Stamin-Up", 2500, "marathon_light", "specialty_longersprint" );
	perk_system( "script_model", ( 2008.49, -110.986, 84.9349 ), "zombie_vending_tombstone_on", ( 0, 180, 0 ), "random", "mus_perks_speed_sting", "Random Perk", 10000, "sleight_light" );
	//////////////////////////////////////////////////////////////////////////////////////////////////duplicatedx2
	perk_system( "script_model", ( 1129.59, -827.221, 117.477 ), "zombie_vending_doubletap2_on", ( 0, -90, 0 ), "original", "mus_perks_doubletap_sting", "Double Tap Root Beer", 20000, "doubletap_light", "specialty_rof" );
	perk_system( "script_model", ( 715.51, -1281.64, 117.271 ), "zombie_vending_revive_on", ( 0, 90, 0 ), "revive" );
    perk_system( "script_model", ( 714.113, -1201.22, 115.431 ), "zombie_vending_sleight_on", ( 0, 90, 0 ), "original", "mus_perks_speed_sting", "Speed Cola", 25000, "sleight_light", "specialty_fastreload" );
    perk_system( "script_model", ( 1059.76, -1238.15, 115.268 ), "p6_anim_zm_buildable_pap_on", ( 0, -90, 0 ), "pap", "zmb_perks_packa_upgrade", "Pack-A-Punch", 5001 );
	perk_system( "script_model", ( 708.964, -1449.04, 123.045 ), "zombie_vending_marathon_on", ( 0, 90, 0 ), "original", "mus_perks_stamin_sting", "Stamin-Up", 2500, "marathon_light", "specialty_longersprint" );
	perk_system( "script_model", ( 844.449, -1009.95, 120.125 ), "zombie_vending_tombstone_on", ( 0, -40, 0 ), "random", "mus_perks_speed_sting", "Random Perk", 10000, "sleight_light" );
}

tps_unlimitedammo_machine_town()
{
	level.price_of_unlimitedammo_machine_points = 20000;
	
	while ( level.round_number < 1 )
	{
		wait 1; 
	}
	
	
	infiniteammo_location = (1132.13, -1065.76, 116.226);
	angles = (0, -90, 0);

	
	unlimitedammo_machine = spawn("script_model", infiniteammo_location);
	unlimitedammo_machine.angles = angles;
	unlimitedammo_machine setModel("zombie_vending_jugg_on");

	
	precachemodel( "zm_collision_perks1" );
	collision = spawn( "script_model", unlimitedammo_machine.origin);
	collision.angles = unlimitedammo_machine.angles;
	collision setModel( "zm_collision_perks1" );

	
	unlimitedammo_machine_trigger = spawn("trigger_radius", infiniteammo_location, 0, 48, 64);
	unlimitedammo_machine_trigger setcursorhint("HINT_NOICON");
	unlimitedammo_machine_trigger sethintstring("Hold ^5F ^7to Buy ^1Infinite Ammo! ^2" + level.price_of_unlimitedammo_machine_points);

	
	level.isinfiniteCooldown = false;

	for(;;)
	{ 
		unlimitedammo_machine_trigger waittill("trigger", player);
		if(player useButtonPressed() && is_player_valid(player) && !level.isinfiniteCooldown)
		{
			if (player.score >= level.price_of_unlimitedammo_machine_points)
			{
				player.score = player.score - level.price_of_unlimitedammo_machine_points;
				player IPrintLnBold(player.name + " Bought Infinite Ammo for ^5" + level.price_of_unlimitedammo_machine_points);
				player playsound("zmb_cha_ching");
				player thread infiniteammo();
				
				level.isinfiniteCooldown = true;
				
				for( i = 80; i > 0; i--)
				{
					unlimitedammo_machine_trigger sethintstring("Cooldown in effect, please wait... " + i);
					wait(1);
					
					if (i % 10 == 0)
					{
						if (i <= 30)
						{
							iPrintLn("^5Infinite Ammo Time: ^1" + i );
						}
						else
						{
							iPrintLn("^5Infinite Ammo Time: ^2" + i );
						}
					}
				}
				
				level.isinfiniteCooldown = false;
				player notify( "stop_inf_ammo" );
				unlimitedammo_machine_trigger sethintstring("Hold ^5F ^7to Buy ^1Infinite Ammo! ^2" + level.price_of_unlimitedammo_machine_points);
			}
			else
			{
				player iPrintLn("Not enough points to purchase Infinite Ammo.");
			}
		}
		wait 1;
	}
}

spawnObject(model, pos, angles)
{
	objet = spawn( "script_model", pos);
	objet setmodel( model );
	objet.angles = angles;
}

infiniteammo()
{
	self endon( "disconnect" );
	self endon( "stop_inf_ammo" );
	for(;;)
	{
		weapon = self getcurrentweapon();
		if( weapon != "none" )
		{
			self setweaponammoclip( weapon, weaponclipsize( weapon ) );
			self givemaxammo( weapon );
		}
		if( self getcurrentoffhand() != "none" )
		{
			self givemaxammo( self getcurrentoffhand() );
		}
		wait 0.05;
	}
}

//--------PERKS-----------------------------------------------------------------------------------------------------------------------------------------------------------------

perk_system( script, pos, model, angles, type, sound, name, cost, fx, perk)
{
	col = spawn( script, pos);
	col setmodel( model );
	col.angles = angles;
	x = spawn( script, pos );
	x setmodel( "zm_collision_perks1" );
	x.angles = angles;
	if(type != "revive")
	{
    	col thread buy_system( perk, sound, name, cost, type );
	}
	if(type != "pap" && type != "revive" )
    {
        col thread play_fx( fx );
    }
	if(type == "revive" )
	{
		col thread perksquickr();
		col thread play_fx( "revive_light" );
	}
}

buy_system( perk, sound, name, cost, type )
{
    self endon( "game_ended" );
    while( 1 )
    {
        foreach( player in level.players )
        {
            if(!player.machine_is_in_use)
			{
                if( distance( self.origin, player.origin ) <= 70 )
                {
				    if (!player hasperk(perk) && !player maps\mp\zombies\_zm_laststand::player_is_in_laststand()) player thread SpawnHint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for " + name + " [Cost: " + cost + "]" );
                    if( type == "original" && player usebuttonpressed() && !player hasperk(perk) && player.score >= cost && !player maps\mp\zombies\_zm_laststand::player_is_in_laststand())
                    {
                        player.machine_is_in_use = 1;
                        player playsound( "zmb_cha_ching" );
                        player.score -= cost;
                        player playsound( sound );
                        player thread DoGivePerk(perk);
						wait 3;
                    	player.machine_is_in_use = 0;
					}
					currgun = player getcurrentweapon();
                    if(type == "pap" && player usebuttonpressed() && !is_weapon_upgraded(currgun) && can_upgrade_weapon(currgun) && player.score >= cost && !player maps\mp\zombies\_zm_laststand::player_is_in_laststand())
                    {
						player.machine_is_in_use = 1;
                        player playsound( "zmb_cha_ching" );
                        player.score -= cost;
                        player playsound( sound );
                        player takeweapon(currgun);
                        gun = player maps\mp\zombies\_zm_weapons::get_upgrade_weapon( currgun, 0 );
                        player giveweapon(player maps\mp\zombies\_zm_weapons::get_upgrade_weapon( currgun, 0 ), 0, player custom_get_pack_a_punch_weapon_options(gun));
                        player switchToWeapon(gun);
						playfx(loadfx( "maps/zombie/fx_zombie_packapunch"), ( 12865.8, -661, -175.5195 ), anglestoforward( ( 0, 180, 55  ) ) ); 
						wait 3;
                    	player.machine_is_in_use = 0;
					}
					else
                    {
                        if( player usebuttonpressed() && player.score < cost )
                        {
                            player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
                        }
                    }
                }
            }
        }
        wait 0.1;
    }
}

perksquickr()
{
    level.solo_revives = 0;
    level.max_solo_revives = 3;
	while( 1 )
	{
        players = get_players();
		foreach( player in level.players )
		{
			if(!player.machine_is_in_use)
			{
				if( distance( self.origin, player.origin ) <= 60 && level.solo_revives < level.max_solo_revives) 
				{
                    if(players.size > 1)
                    {
						if (!player hasperk("specialty_quickrevive") && !player maps\mp\zombies\_zm_laststand::player_is_in_laststand()) player thread SpawnHint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for Revive [Cost: 1500]" );
                    }
                    else
                    {
					    if (!player hasperk("specialty_quickrevive") && !player maps\mp\zombies\_zm_laststand::player_is_in_laststand()) player thread SpawnHint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for Revive [Cost: 500]" );
                    }
					if((players.size > 1) && player usebuttonpressed() && !(player hasperk( "specialty_quickrevive" )) && (player.score >= 1500) && !(self.lock) && !player maps\mp\zombies\_zm_laststand::player_is_in_laststand()) 
					{
						player.machine_is_in_use = 1;
						self.lock = 1;
                        level.solo_revives = 0;
						player playsound( "zmb_cha_ching" );
						player.score -= 1500;
						player playsound ( "mus_perks_revive_sting" );
						player thread DoGivePerk("specialty_quickrevive");
						wait 1;
						weapona = self getcurrentweapon();
						self switchToWeapon(weapona);
						wait 3;
						self.lock = 0;
						player.machine_is_in_use = 0;
					}
                    if(!level.max_revives && (players.size <= 1) && player usebuttonpressed() && !(player hasperk( "specialty_quickrevive" )) && (player.score >= 500) && !(self.lock ) && !maps\mp\zombies\_zm_laststand::player_is_in_laststand()) 
					{
						player.machine_is_in_use = 1;
						self.lock = 1;
                        level.solo_revives++;
						player playsound( "zmb_cha_ching" );
						player.score -= 500;
						player playsound ( "mus_perks_revive_sting" );
						player thread DoGivePerk("specialty_quickrevive");
						wait 1;
						weapona = self getcurrentweapon();
						self switchToWeapon(weapona);
						wait 3;
						self.lock = 0;
						player.machine_is_in_use = 0;
						//self.setorigin( (2366.8, -731.829, -999 ) );
					}
                    if(level.max_revives && (players.size <= 1) && player usebuttonpressed() && (player.score >= 500) && !(self.lock) && !player maps\mp\zombies\_zm_laststand::player_is_in_laststand()) 
					{
                        player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "oh_shit" );
                        wait 3;
                    }
                    if(level.solo_revives >= level.max_solo_revives)
                    {
                        level.max_revives = 1;
                    }
					else 
                    {
                        if((players.size == 1) && player usebuttonpressed() && player.score < 500)
					    {
						    player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
					    }
                        if((players.size > 1) && player usebuttonpressed() && player.score < 1500)
					    {
						    player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
					    }
                    }
				}

			}
		}
		wait 0.1;
	}

}

play_fx( fx )
{
	playfxontag( level._effect[ fx ], self, "tag_origin" );
}

noncollision( pos, model, angles )
{
	noncol = spawn( "script_model", pos );
	noncol setmodel( model );
	noncol.angles = angles;
}

drink()
{
    self allowProne(false);
    self allowSprint(false);
    self disableoffhandweapons();
    self disableweaponcycling();
    weapona = self getcurrentweapon();
    weaponb = "zombie_perk_bottle_tombstone";
    self giveweapon( weaponb );
    self switchtoweapon( weaponb );
    self waittill( "weapon_change_complete" );
    self enableoffhandweapons();
    self enableweaponcycling();
    self takeweapon( weaponb );
    self switchtoweapon( weapona );
    self maps\mp\zombies\_zm_audio::playerexert( "burp" );
    self setblur( 4, 0.1 );
    wait 0.1;
    self setblur( 0, 0.1 );
    self allowProne(true);
    self allowSprint(true);
}

SpawnHint( origin, width, height, cursorhint, string )
{
    hint = spawn( "trigger_radius", origin, 1, width, height );
    hint setcursorhint( cursorhint, hint );
    hint sethintstring( string );
    hint setvisibletoall();
    wait 0.2;
    hint delete();
}

doGivePerk(perk)
{
	
    self endon("disconnect");
    self endon("death");
    level endon("game_ended");
    self endon("perk_abort_drinking");
    if (!(self hasperk(perk) || (self maps\mp\zombies\_zm_perks::has_perk_paused(perk))))
    {
        gun = self maps\mp\zombies\_zm_perks::perk_give_bottle_begin(perk);
        evt = self waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete");
        if (evt == "weapon_change_complete")
            self thread maps\mp\zombies\_zm_perks::wait_give_perk(perk, 1);
        self maps\mp\zombies\_zm_perks::perk_give_bottle_end(gun, perk);
        if (self maps\mp\zombies\_zm_laststand::player_is_in_laststand() || isDefined(self.intermission) && self.intermission)
            return;
        self notify("burp");
    }
}

custom_get_pack_a_punch_weapon_options( weapon )
{
	if( !(IsDefined( self.pack_a_punch_weapon_options )) )
	{
		self.pack_a_punch_weapon_options = [];
	}
	if( !(is_weapon_upgraded( weapon )) )
	{
		return self calcweaponoptions( 0, 0, 0, 0, 0 );
	}
	if( IsDefined( self.pack_a_punch_weapon_options[ weapon] ) )
	{
		return self.pack_a_punch_weapon_options[ weapon];
	}
	smiley_face_reticle_index = 1;
	base = get_base_name( weapon );
	if( base == "m16_zm" || weapon == "m16_upgraded_zm" || base == "qcw05_upgraded_zm" || weapon == "qcw05_zm" || base == "fivesevendw_upgraded_zm" || weapon == "fivesevendw_zm" || base == "fiveseven_upgraded_zm" || weapon == "fiveseven_zm" || base == "m32_upgraded_zm" || weapon == "m32_zm" || base == "ray_gun_upgraded_zm" || weapon == "ray_gun_zm" || base == "raygun_mark2_upgraded_zm" || weapon == "raygun_mark2_zm" || base == "m1911_upgraded_zm" || weapon == "m1911_zm" || base == "knife_ballistic_upgraded_zm" || weapon == "knife_ballistic_zm")
	{
		camo_index = 39;
	}
	else
	{
		camo_index = 44;
	}
	lens_index = randomintrange( 0, 6 );
	reticle_index = randomintrange( 0, 16 );
	reticle_color_index = randomintrange( 0, 6 );
	plain_reticle_index = 16;
	r = randomint( 10 );
	use_plain = r < 3;
	if( base == "saritch_upgraded_zm" )
	{
		reticle_index = smiley_face_reticle_index;
	}
	else
	{
		if( use_plain )
		{
			reticle_index = plain_reticle_index;
		}
	}
	scary_eyes_reticle_index = 8;
	purple_reticle_color_index = 3;
	if( reticle_index == scary_eyes_reticle_index )
	{
		reticle_color_index = purple_reticle_color_index;
	}
	letter_a_reticle_index = 2;
	pink_reticle_color_index = 6;
	if( reticle_index == letter_a_reticle_index )
	{
		reticle_color_index = pink_reticle_color_index;
	}
	letter_e_reticle_index = 7;
	green_reticle_color_index = 1;
	if( reticle_index == letter_e_reticle_index )
	{
		reticle_color_index = green_reticle_color_index;
	}
	self.pack_a_punch_weapon_options[weapon] = self calcweaponoptions( camo_index, lens_index, reticle_index, reticle_color_index );
	return self.pack_a_punch_weapon_options[ weapon];

}

//--------PERKS-----------------------------------------------------------------------------------------------------------------------------------------------------------------


box_init() 
{
	setdvar( "magic_chest_movable", "0" );
	if ( !isDefined( level.magic_box_zbarrier_state_func ) )
	{
		level.magic_box_zbarrier_state_func = ::process_magic_box_zbarrier_state;
	}
	if ( isDefined( level.using_locked_magicbox ) && level.using_locked_magicbox )
	{
		maps\mp\zombies\_zm_magicbox_lock::init();
	}

	level.chests = getstructarray( "treasure_chest_use", "targetname" );
	level.chests = [];
	start_chest = spawnstruct();
	//start_chest.origin = ( 2351.16, -635.286, -55.8761 );
	start_chest.origin = ( 2444.02, -27.9324, 121.285 );
	start_chest.angles = ( 0, 90, 0 );
	start_chest.origin = ( 2444.02, -27.9324, 121.285 );
	start_chest.angles = ( 0, 90, 0 );
	start_chest.script_noteworthy = "start_chest";
	start_chest.zombie_cost = 950;
	level.chests[ 0 ] = start_chest;
	treasure_chest_init( "start_chest" );
	if ( level.createfx_enabled )
	{
		return;
	}
	if ( !isDefined( level.magic_box_check_equipment ) )
	{
		level.magic_box_check_equipment = ::default_magic_box_check_equipment;
	}
	level thread magicbox_host_migration();
	//foreach( weapon in level.zombie_weapons) //all weapons in box
	//{
	//	weapon.is_in_box = 1;
	//}
}

treasure_chest_init( start_chest_name )
{
	flag_init( "moving_chest_enabled" );
	flag_init( "moving_chest_now" );
	flag_init( "chest_has_been_used" );
	level.chest_moves = 0;
	level.chest_level = 0;
	if ( level.chests.size == 0 )
	{
		return;
	}
	for ( i = 0; i < level.chests.size; i++ )
	{
		level.chests[ i ].box_hacks = [];
		level.chests[ i ].orig_origin = level.chests[ i ].origin;
		level.chests[ i ] get_chest_pieces();
		if ( isDefined( level.chests[ i ].zombie_cost ) )
		{
			level.chests[ i ].old_cost = level.chests[ i ].zombie_cost;
		}
		else
		{
			level.chests[ i ].old_cost = 950;
		}
	}
	level.chest_accessed = 0;
	init_starting_chest_location( start_chest_name );
	array_thread( level.chests, ::treasure_chest_think );
}

get_chest_pieces()
{
	self.chest_box = getent( self.script_noteworthy + "_zbarrier", "script_noteworthy" );
	self.chest_box.origin = ( 2444.02, -27.9324, 121.285 );
	self.chest_box.angles = ( 45, 180, 45 );
	self.chest_box.origin = ( 2444.02, -27.9324, 121.285 );
	self.chest_box.angles = ( 45, 180, 45 );
	collision = spawn( "script_model", self.chest_box.origin );
	collision.angles = self.chest_box.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision disconnectpaths();
	collision = spawn( "script_model", self.chest_box.origin - ( 0, 0, 0 ) );
	collision.angles = self.chest_box.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision disconnectpaths();
	collision = spawn( "script_model", self.chest_box.origin + ( 0, 0, 0 ) );
	collision.angles = self.chest_box.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision disconnectpaths();
	self.chest_rubble = [];
	rubble = getentarray( self.script_noteworthy + "_rubble", "script_noteworthy" );
	for ( i = 0; i < rubble.size; i++ )
	{
		if ( distancesquared( self.origin, rubble[ i ].origin ) < 10000 )
		{
			self.chest_rubble[ self.chest_rubble.size ] = rubble[ i ];
		}
	}
	self.zbarrier = getent( self.script_noteworthy + "_zbarrier", "script_noteworthy" );
	if ( isDefined( self.zbarrier ) )
	{
		self.zbarrier zbarrierpieceuseboxriselogic( 3 );
		self.zbarrier zbarrierpieceuseboxriselogic( 4 );
	}
	self.unitrigger_stub = spawnstruct();
	self.unitrigger_stub.origin = self.origin + anglesToRight( self.angles * -22.5 );
	self.unitrigger_stub.angles = self.angles;
	self.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	self.unitrigger_stub.script_width = 104;
	self.unitrigger_stub.script_height = 50;
	self.unitrigger_stub.script_length = 60;
	self.unitrigger_stub.trigger_target = self;
	unitrigger_force_per_player_triggers( self.unitrigger_stub, 1 );
	self.unitrigger_stub.prompt_and_visibility_func = ::boxtrigger_update_prompt;
	self.zbarrier.owner = self;
}

//--------BOX------------------------------------------------------------------------------------------------------------------------------------------------------------------

givePointsToAllPlayers()
{
    currentRound = level.round_number;
	
	if (currentRound >= 30)
    {
        foreach (player in level.players)
        {
            player.score += 150;
        }
    }
	else if (currentRound >= 25)
    {
        foreach (player in level.players)
        {
            player.score += 100;
        }
    }
    else if (currentRound >= 20)
    {
        foreach (player in level.players)
        {
            player.score += 30;
        }
    }
    else if (currentRound >= 15)
    {
        foreach (player in level.players)
        {
            player.score += 20;
        }
    }
    else if (currentRound >= 10)
    {
        foreach (player in level.players)
        {
            player.score += 15;
        }
    }
    else if (currentRound >= 5)
    {
        foreach (player in level.players)
        {
            player.score += 8;
        }
    }
    else if (currentRound >= 3)
    {
        foreach (player in level.players)
        {
            player.score += 3;
        }
    }
	else if (currentRound >= 2)
    {
        foreach (player in level.players)
        {
            player.score += 2;
        }
    }
    else if (currentRound >= 1)
    {
        foreach (player in level.players)
        {
            player.score += 1;
        }
    }
}

roundMonitor()
{
    level endon("game_ended");
	

    oldRound = 0;
    while (1)
    {
        newRound = level.round;
        if (newRound > oldRound)
        {
            oldRound = newRound;
            level thread givePointsToAllPlayers();
        }
		
        wait 0.8;
    }
}