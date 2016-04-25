//NFS Underground 2 Drift Counter for SA-MP by Gamer_Z
//The includes
#include <a_samp>
#include <DriftPointsCounter>

#define MAX_NITRO (700)
#define POINTS_TO_GET_ONE_NITRO (600)
//Variables for the textdraws
new Text:Textdraw0[MAX_PLAYERS];
new Text:Textdraw1[MAX_PLAYERS];
new Text:Textdraw2[MAX_PLAYERS];
new Text:Textdraw3[MAX_PLAYERS];
new Text:Textdraw4[MAX_PLAYERS];
new Text:Textdraw5[MAX_PLAYERS];
new Text:Textdraw6[MAX_PLAYERS];
new Text:Textdraw7[MAX_PLAYERS];
new Text:Textdraw8[MAX_PLAYERS];
new Text:Textdraw9[MAX_PLAYERS];

//global string variable
new
	s[255];

//drifting enumerator
enum DriftingInfo
{
	Best,
	Score,
	Combo,
	bool:using,
	NitroLeft
}

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
//the drifting variables for best score, score and combo
new Drift_VAR[MAX_PLAYERS][DriftingInfo];

//define our variable which will temporary hold our points number and a Timer variable for remembering which Timer we set
new CurrPoints[MAX_PLAYERS] = 0;
new Timer[MAX_PLAYERS] = -1;

public OnPlayerConnect(playerid)
{
    ResetAll(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid,reason)
{
    ResetAll(playerid);
	return 1;
}

stock ResetAll(playerid)//make our reset code in case you need it
{
	TextDrawHideForPlayer(playerid, Textdraw0[playerid]);
	TextDrawHideForPlayer(playerid, Textdraw1[playerid]);
	TextDrawHideForPlayer(playerid, Textdraw2[playerid]);
	TextDrawHideForPlayer(playerid, Textdraw3[playerid]);

	TextDrawHideForPlayer(playerid, Textdraw4[playerid]);
	TextDrawHideForPlayer(playerid, Textdraw5[playerid]);
	TextDrawHideForPlayer(playerid, Textdraw6[playerid]);

	TextDrawHideForPlayer(playerid, Textdraw7[playerid]);
	
	TextDrawHideForPlayer(playerid, Textdraw8[playerid]);
	TextDrawHideForPlayer(playerid, Textdraw9[playerid]);
	
    if(Timer[playerid] != -1)KillTimer(Timer[playerid]);
    Timer[playerid] = -1;
    Drift_VAR[playerid][using] = false;
    Drift_VAR[playerid][NitroLeft] = 0;
    Drift_VAR[playerid][Best] = Drift_VAR[playerid][Score] = CurrPoints[playerid] = 0;
    return 1;
}

public OnPlayerCommandText(playerid,cmdtext[])
{
	if(!strcmp(cmdtext,"/drift-reset"))
	{
	    if(Timer[playerid] != -1)KillTimer(Timer[playerid]);
		Drift_VAR[playerid][Best] = Drift_VAR[playerid][Score] = 0;
		format(s,255,"Best:~Y~%d~N~~N~~N~~N~~W~Score:~R~%d",Drift_VAR[playerid][Best],Drift_VAR[playerid][Score]);
		TextDrawSetString(Textdraw1[playerid],s);
    	TextDrawSetString(Textdraw3[playerid],"Gain ~G~X2~W~ with:~N~_______350");
    	TextDrawSetString(Textdraw2[playerid],"~G~X1");
    	return 1;
	}
	return 0;
}

public OnFilterScriptInit()
{
	//create the textdraws
	for(new playerid = 0; playerid < GetMaxPlayers()/*MAX_PLAYERS*/; ++playerid)//F*ck the limit...
	{
		Textdraw0[playerid] = TextDrawCreate(20.000000, 131.000000, "_~N~_~N~_~N~_~N~_~N~_~N~_~N~_~N~_~N~_~N~_");
		TextDrawBackgroundColor(Textdraw0[playerid], 255);
		TextDrawFont(Textdraw0[playerid], 1);
		TextDrawLetterSize(Textdraw0[playerid], 0.500000, 0.699998);
		TextDrawColor(Textdraw0[playerid], -1);
		TextDrawSetOutline(Textdraw0[playerid], 0);
		TextDrawSetProportional(Textdraw0[playerid], 1);
		TextDrawSetShadow(Textdraw0[playerid], 1);
		TextDrawUseBox(Textdraw0[playerid], 1);
		TextDrawBoxColor(Textdraw0[playerid], 119);
		TextDrawTextSize(Textdraw0[playerid], 151.000000, 0.000000);

		Textdraw1[playerid] = TextDrawCreate(19.000000, 132.000000, "Best:~Y~1000000~N~~N~~N~~N~~W~Score:~R~1000000");
		TextDrawBackgroundColor(Textdraw1[playerid], 369098796);
		TextDrawFont(Textdraw1[playerid], 2);
		TextDrawLetterSize(Textdraw1[playerid], 0.400000, 1.500000);
		TextDrawColor(Textdraw1[playerid], -1);
		TextDrawSetOutline(Textdraw1[playerid], 1);
		TextDrawSetProportional(Textdraw1[playerid], 1);

		Textdraw2[playerid] = TextDrawCreate(19.000000, 149.000000, "~g~X1");
		TextDrawBackgroundColor(Textdraw2[playerid], 369098796);
		TextDrawFont(Textdraw2[playerid], 2);
		TextDrawLetterSize(Textdraw2[playerid], 0.600000, 3.399998);
		TextDrawColor(Textdraw2[playerid], -1);
		TextDrawSetOutline(Textdraw2[playerid], 1);
		TextDrawSetProportional(Textdraw2[playerid], 1);

		Textdraw3[playerid] = TextDrawCreate(62.000000, 155.000000, "Gain ~G~X2~W~ with:~N~_______350");
		TextDrawBackgroundColor(Textdraw3[playerid], 369098796);
		TextDrawFont(Textdraw3[playerid], 2);
		TextDrawLetterSize(Textdraw3[playerid], 0.300000, 1.100000);
		TextDrawColor(Textdraw3[playerid], -1);
		TextDrawSetOutline(Textdraw3[playerid], 1);
		TextDrawSetProportional(Textdraw3[playerid], 1);

		Textdraw4[playerid] = TextDrawCreate(640.000000, 412.000000, "~N~");
		TextDrawBackgroundColor(Textdraw4[playerid], 255);
		TextDrawFont(Textdraw4[playerid], 1);
		TextDrawLetterSize(Textdraw4[playerid], 0.519999, 1.899999);
		TextDrawColor(Textdraw4[playerid], -1);
		TextDrawSetOutline(Textdraw4[playerid], 0);
		TextDrawSetProportional(Textdraw4[playerid], 1);
		TextDrawSetShadow(Textdraw4[playerid], 1);
		TextDrawUseBox(Textdraw4[playerid], 1);
		TextDrawBoxColor(Textdraw4[playerid], 119);
		TextDrawTextSize(Textdraw4[playerid], 563.000000, 0.000000);

		Textdraw5[playerid] = TextDrawCreate(619.000000, 419.000000, "o");
		TextDrawBackgroundColor(Textdraw5[playerid], 369098796);
		TextDrawFont(Textdraw5[playerid], 2);
		TextDrawLetterSize(Textdraw5[playerid], 0.300000, 0.699998);
		TextDrawColor(Textdraw5[playerid], -1);
		TextDrawSetOutline(Textdraw5[playerid], 1);
		TextDrawSetProportional(Textdraw5[playerid], 1);

		Textdraw6[playerid] = TextDrawCreate(567.000000, 408.000000, "100 km/h~n~_____125");
		TextDrawBackgroundColor(Textdraw6[playerid], 369098796);
		TextDrawFont(Textdraw6[playerid], 2);
		TextDrawLetterSize(Textdraw6[playerid], 0.349999, 1.299996);
		TextDrawColor(Textdraw6[playerid], -1);
		TextDrawSetOutline(Textdraw6[playerid], 1);
		TextDrawSetProportional(Textdraw6[playerid], 1);

		Textdraw7[playerid] = TextDrawCreate(320.000000, 150.000000, "1000000");
		TextDrawAlignment(Textdraw7[playerid], 2);
		TextDrawBackgroundColor(Textdraw7[playerid], 369098796);
		TextDrawFont(Textdraw7[playerid], 3);
		TextDrawLetterSize(Textdraw7[playerid], 0.449999, 1.500000);
		TextDrawColor(Textdraw7[playerid], 0xF9FF8FEE);
		TextDrawSetOutline(Textdraw7[playerid], 1);
		TextDrawSetProportional(Textdraw7[playerid], 1);
		
//
		Textdraw8[playerid] = TextDrawCreate(601.000000, 399.000000, "N2O");
		TextDrawAlignment(Textdraw8[playerid], 2);
		TextDrawBackgroundColor(Textdraw8[playerid], 255);
		TextDrawFont(Textdraw8[playerid], 1);
		TextDrawLetterSize(Textdraw8[playerid], 0.250000, 0.599998);
		TextDrawColor(Textdraw8[playerid], -1);
		TextDrawSetOutline(Textdraw8[playerid], 0);
		TextDrawSetProportional(Textdraw8[playerid], 1);
		TextDrawSetShadow(Textdraw8[playerid], 1);
		TextDrawUseBox(Textdraw8[playerid], 1);
		TextDrawBoxColor(Textdraw8[playerid], 255);
		TextDrawTextSize(Textdraw8[playerid], 527.000000, 63.000000);

		Textdraw9[playerid] = TextDrawCreate(570.000000, 396.000000, "////////////////////////////////////////////////////////////////////////////////////////////////////");
		TextDrawBackgroundColor(Textdraw9[playerid], 255);
		TextDrawFont(Textdraw9[playerid], 1);
		TextDrawLetterSize(Textdraw9[playerid], 0.039999, 0.999998);
		TextDrawColor(Textdraw9[playerid], 0xFFFF00AA);
		TextDrawSetOutline(Textdraw9[playerid], 0);
		TextDrawSetProportional(Textdraw9[playerid], 1);
		TextDrawSetShadow(Textdraw9[playerid], 1);
	}
	//configure the DriftingPointsCounter plugin
	DriftSet_DamageCheck();//enable damage checking
	DriftSet_UpdateDelay(8);//set the each plugin loop to 8 sa-mp ticks (5 ms sleep + tick time of sa-mp for executing it's loops etc and other plugins)
	DriftSet_Divider(3000);//the points divider so our players won't get superb high score, how bigger the divider , the less score they get
	DriftSet_StartEndDelay(30);//the counter in ticks (UpdateDelay*30 sa-mp ticks) which will say when a player is not drifting anymore
	DriftSet_MinimalAngle(15.5);//minimal angle to start a drift
 	DriftSet_MinimalSpeed(25.5);//minimal speed ""
	return 1;
}

public OnFilterScriptExit()
{
	for(new playerid = 0; playerid < GetMaxPlayers(); ++playerid)
	{
	    if(Timer[playerid] != (-1))KillTimer(Timer[playerid]);
		TextDrawHideForPlayer(playerid, Textdraw0[playerid]);
		TextDrawHideForPlayer(playerid, Textdraw1[playerid]);
		TextDrawHideForPlayer(playerid, Textdraw2[playerid]);
		TextDrawHideForPlayer(playerid, Textdraw3[playerid]);

		TextDrawHideForPlayer(playerid, Textdraw4[playerid]);
		TextDrawHideForPlayer(playerid, Textdraw5[playerid]);
		TextDrawHideForPlayer(playerid, Textdraw6[playerid]);

		TextDrawHideForPlayer(playerid, Textdraw7[playerid]);
		
		TextDrawHideForPlayer(playerid, Textdraw8[playerid]);
		TextDrawHideForPlayer(playerid, Textdraw9[playerid]);
		
		TextDrawDestroy(Textdraw0[playerid]);
		TextDrawDestroy(Textdraw1[playerid]);
		TextDrawDestroy(Textdraw2[playerid]);
		TextDrawDestroy(Textdraw3[playerid]);
		TextDrawDestroy(Textdraw4[playerid]);
		TextDrawDestroy(Textdraw5[playerid]);
		TextDrawDestroy(Textdraw6[playerid]);
		TextDrawDestroy(Textdraw7[playerid]);
		TextDrawDestroy(Textdraw8[playerid]);
		TextDrawDestroy(Textdraw9[playerid]);
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)//player is driver
	{
		new Car = GetPlayerVehicleID(playerid), Model = GetVehicleModel(Car);//get the VehicleID and Model
		switch(Model)//check model for allowed type to add nitro, if not allowed return 0;
		{
			case 446,432,448,452,424,453,454,461,462,463,468,471,430,472,449,473,481,484,493,495,509,510,521,538,522,523,532,537,570,581,586,590,569,595,604,611: return 0;
		}
		if((PRESSED(KEY_FIRE) || PRESSED(KEY_ACTION))//is player holding key_fire OR key_action?
		&& Drift_VAR[playerid][NitroLeft] > 0)//and his nitro is greater than 0?
		{
		    Drift_VAR[playerid][using] = true;//then the player is using nitro
			AddVehicleComponent(Car, 1010);//so we add the component to his vehicle
		}
		else
		{
		    Drift_VAR[playerid][using] = false;//player is not using nitro
			RemoveVehicleComponent(Car,1010);//so we remove the component
		}
	}
	return 1;
}

//our callback which gets called when the player starts drifting
public OnPlayerDriftStart(playerid)
{
    if(Timer[playerid] != (-1))KillTimer(Timer[playerid]);//check if we already created a timer, if yes - destroy it
    CurrPoints[playerid] = 0;//set the current drift points to 0
 	
 	//show the textdraw for counting current drift points and set it's text to "0"
    TextDrawShowForPlayer(playerid, Textdraw7[playerid]);
    TextDrawSetString(Textdraw7[playerid],"0");
    
    //do some combo (X's) checks and set the according information, like in NFSUG2
	if(Drift_VAR[playerid][Combo] == 1)//got x1
	{
	    TextDrawSetString(Textdraw2[playerid],"~G~X1");
	    TextDrawSetString(Textdraw3[playerid],"Gain ~G~X2~W~ with:~N~_______350");
	}else if(Drift_VAR[playerid][Combo] == 2)//got x2
	{
	    TextDrawSetString(Textdraw2[playerid],"~G~X2");
	    TextDrawSetString(Textdraw3[playerid],"Gain ~G~X3~W~ with:~N~_______1400");
	}else if(Drift_VAR[playerid][Combo] == 3)//got x3
	{
	    TextDrawSetString(Textdraw2[playerid],"~G~X3");
		TextDrawSetString(Textdraw3[playerid],"Gain ~G~X4~W~ with:~N~_______4200");
	}else if(Drift_VAR[playerid][Combo] == 4)//got x4
	{
	    TextDrawSetString(Textdraw2[playerid],"~G~X4");
	    TextDrawSetString(Textdraw3[playerid],"Gain ~G~X5~W~ with:~N~_______11500");
	}else//got x5
	{
	    TextDrawSetString(Textdraw2[playerid],"~G~X5");
		TextDrawSetString(Textdraw3[playerid],"____ ~G~MAX~W~ ~N~_______---");
	}
	return 1;
}

//our callback which gets called when the player is drifting AFTER OnPlayerDriftStart is called.
public OnPlayerDriftUpdate(playerid,value,combo,flagid,Float:distance,Float:speed)
{
	CurrPoints[playerid]+=(value*Drift_VAR[playerid][Combo]);//append to the current drift points our drifting score

	//again some X's checks
	if(CurrPoints[playerid] < 350)//get x1
	{
	    if(Drift_VAR[playerid][Combo] < 2)//check if the player hasn't a higher combo yet
	    {
	    	Drift_VAR[playerid][Combo] = 1;
	    	TextDrawSetString(Textdraw2[playerid],"~G~X1");
	    	TextDrawSetString(Textdraw3[playerid],"Gain ~G~X2~W~ with:~N~_______350");
		}
	}else if(CurrPoints[playerid] < 1400)//get x2
	{
	    if(Drift_VAR[playerid][Combo] < 3)
	    {
	    	Drift_VAR[playerid][Combo] = 2;
	    	TextDrawSetString(Textdraw2[playerid],"~G~X2");
	    	TextDrawSetString(Textdraw3[playerid],"Gain ~G~X3~W~ with:~N~_______1400");
		}
	}else if(CurrPoints[playerid] < 4200)//get x3
	{
	    if(Drift_VAR[playerid][Combo] < 4)
	    {
	    	Drift_VAR[playerid][Combo] = 3;
	    	TextDrawSetString(Textdraw2[playerid],"~G~X3");
			TextDrawSetString(Textdraw3[playerid],"Gain ~G~X4~W~ with:~N~_______4200");
		}
	}else if(CurrPoints[playerid] < 11500)//get x4
	{
 		if(Drift_VAR[playerid][Combo] < 5)
	    {
	    	Drift_VAR[playerid][Combo] = 4;
	    	TextDrawSetString(Textdraw2[playerid],"~G~X4");
	    	TextDrawSetString(Textdraw3[playerid],"Gain ~G~X5~W~ with:~N~_______11500");
		}
	}else//get x5
	{
	    Drift_VAR[playerid][Combo] = 5;
	    TextDrawSetString(Textdraw2[playerid],"~G~X5");
		TextDrawSetString(Textdraw3[playerid],"____ ~G~MAX~W~ ~N~_______---");
	}
	//format and set the current drifting points
	format(s,255,"%d",CurrPoints[playerid]);
	TextDrawSetString(Textdraw7[playerid],s);
	
	//update our main scoreboard
	format(s,255,"Best:~Y~%d~N~~N~~N~~N~~W~Score:~R~%d",Drift_VAR[playerid][Best],Drift_VAR[playerid][Score]);
	TextDrawSetString(Textdraw1[playerid],s);
	return 1;
}

//this gets called after the player didn't start a drift in the required time, so his drift is ended
public OnPlayerDriftEnd(playerid,value,combo,reason)
{
    Drift_SetPlayerCheck(playerid,0);//we disable the player from the DriftingPointsCounter, this player cannot drift now, OnPlayerDriftStart won't be called
	if(reason != DRIFT_REASON_CAR_DAMAGED)//The car wasn't damaged, so the drift was succesful (however the player could jump out of the car...
	{
	    if(CurrPoints[playerid] > Drift_VAR[playerid][Best])Drift_VAR[playerid][Best] = CurrPoints[playerid];//check if the player beat his best score, if yes set the temporary score to the best score
		Drift_VAR[playerid][Score]+=CurrPoints[playerid];//update our main score with our temporary score
        Drift_VAR[playerid][NitroLeft]+=floatround(CurrPoints[playerid]/POINTS_TO_GET_ONE_NITRO);//some nitro adding code
        if(Drift_VAR[playerid][NitroLeft] > MAX_NITRO)Drift_VAR[playerid][NitroLeft] = MAX_NITRO;//set a MAX on nitro value
		SetTimerEx("RestoreDrift",150,0,"d",playerid);//Set a timed public execution with the passed playerid parameter
	}
	else if(reason == DRIFT_REASON_CAR_DAMAGED)//OMG WTF NISIBNFIN$!!! THE CAR GOT DAMAGED OHWTF! BAN HIMWM!!!!
	{
	    if(Timer[playerid] != (-1))KillTimer(Timer[playerid]);
	    Drift_VAR[playerid][Combo] = 1;
	    TextDrawSetString(Textdraw2[playerid],"~G~X1");
	    TextDrawSetString(Textdraw3[playerid],"Gain ~G~X2~W~ with:~N~_______350");
	    Timer[playerid] = -1;
		format(s,255,"~r~%d",CurrPoints[playerid]);//make our textdraw red with ~r~
		TextDrawSetString(Textdraw7[playerid],s);//update the textdraw
		SetTimerEx("RestoreDrift",1250,0,"d",playerid);//we won't hide the textdraw now, just let the player see the red buhahaha, he deserves it.
	}
	
	CurrPoints[playerid] = 0;//set the temporary points (again) to 0, so the next drift will have a 'fresh start'
	
	if(Timer[playerid] != (-1))KillTimer(Timer[playerid]);//again our timer thingy...
	if(Drift_VAR[playerid][Combo] == 1)//got x1
	{
	    TextDrawSetString(Textdraw2[playerid],"~G~X1");
	    TextDrawSetString(Textdraw3[playerid],"Gain ~G~X2~W~ with:~N~_______350");
	    Timer[playerid] = -1;
	}else if(Drift_VAR[playerid][Combo] == 2)//got x2
	{
	    TextDrawSetString(Textdraw2[playerid],"~G~X2");
	    TextDrawSetString(Textdraw3[playerid],"Gain ~G~X3~W~ with:~N~_______1400");

		//
		Timer[playerid] = SetTimerEx("DecreaseX",5000,0,"d",playerid);
		//if the player doesn't start a drift within 5 secs,
		//the timer won't get killed so this public will get called,
		//same apply for all other lines below
	}else if(Drift_VAR[playerid][Combo] == 3)//got x3
	{
	    TextDrawSetString(Textdraw2[playerid],"~G~X3");
		TextDrawSetString(Textdraw3[playerid],"Gain ~G~X4~W~ with:~N~_______4200");
		Timer[playerid] = SetTimerEx("DecreaseX",3500,0,"d",playerid);
	}else if(Drift_VAR[playerid][Combo] == 4)//got x4
	{
	    TextDrawSetString(Textdraw2[playerid],"~G~X4");
	    TextDrawSetString(Textdraw3[playerid],"Gain ~G~X5~W~ with:~N~_______11500");
	    Timer[playerid] = SetTimerEx("DecreaseX",2500,0,"d",playerid);
	}else//got x5
	{
	    TextDrawSetString(Textdraw2[playerid],"~G~X5");
		TextDrawSetString(Textdraw3[playerid],"____ ~G~MAX~W~ ~N~_______---");
		Timer[playerid] = SetTimerEx("DecreaseX",1000,0,"d",playerid);
	}
	//update our main scoreboard again
	format(s,255,"Best:~Y~%d~N~~N~~N~~N~~W~Score:~R~%d",Drift_VAR[playerid][Best],Drift_VAR[playerid][Score]);
	TextDrawSetString(Textdraw1[playerid],s);
	return 1;
}

//here is our little magic to enable the drifting again
forward RestoreDrift(playerid);
public RestoreDrift(playerid)
{
    Drift_SetPlayerCheck(playerid,1);//enable the player in the plugin
    TextDrawHideForPlayer(playerid, Textdraw7[playerid]);//hide the temporary score textdraw, no more red or normal score
	return 1;
}

//here is our X's decrease code.. we won't give the player unlimited X's, he has to use them in time!
forward DecreaseX(playerid);
public DecreaseX(playerid)
{
    Drift_VAR[playerid][Combo]-=1;
    if(Drift_VAR[playerid][Combo] < 1)Drift_VAR[playerid][Combo] = 1;//prevention...
    if(Timer[playerid] != (-1))KillTimer(Timer[playerid]);//you've seen this before my mate...
    
    //now our X's decrease code
	if(Drift_VAR[playerid][Combo] == 1)//got x1
	{
	    TextDrawSetString(Textdraw2[playerid],"~G~X1");
	    TextDrawSetString(Textdraw3[playerid],"Gain ~G~X2~W~ with:~N~_______350");
	    Timer[playerid] = -1;
	}else if(Drift_VAR[playerid][Combo] == 2)//got x2
	{
	    //so the player had X3, now he will have X2....
	    //poor player didn't make it in time,
	    //anyway he still has X2, so let's give him 5 seconds to re-drift and get him some points!
	    //same apples for lines below
	    TextDrawSetString(Textdraw2[playerid],"~G~X2");
	    TextDrawSetString(Textdraw3[playerid],"Gain ~G~X3~W~ with:~N~_______1400");
	    Timer[playerid] = SetTimerEx("DecreaseX",5000,0,"d",playerid);//call this callback again
	}else if(Drift_VAR[playerid][Combo] == 3)//got x3
	{
	    TextDrawSetString(Textdraw2[playerid],"~G~X3");
		TextDrawSetString(Textdraw3[playerid],"Gain ~G~X4~W~ with:~N~_______4200");
		Timer[playerid] = SetTimerEx("DecreaseX",3500,0,"d",playerid);
	}else if(Drift_VAR[playerid][Combo] == 4)//got x4
	{
	    TextDrawSetString(Textdraw2[playerid],"~G~X4");
	    TextDrawSetString(Textdraw3[playerid],"Gain ~G~X5~W~ with:~N~_______11500");
	    Timer[playerid] = SetTimerEx("DecreaseX",2500,0,"d",playerid);
	}else//got x5
	{
	    TextDrawSetString(Textdraw2[playerid],"~G~X5");
		TextDrawSetString(Textdraw3[playerid],"____ ~G~MAX~W~ ~N~_______---");
		Timer[playerid] = SetTimerEx("DecreaseX",1000,0,"d",playerid);
	}
	return 1;
}

//variable for holding float data
new Float:fvar[8];
public OnPlayerUpdate(playerid)//our little friend, which can lag us.
{
	if(!IsPlayerInAnyVehicle(playerid))return 1;//player is not in a vehicle
	if(Drift_VAR[playerid][using] == true)//if player is using nitro
		Drift_VAR[playerid][NitroLeft]--;//decrease his amount of nitro by 1
	new vehid = GetPlayerVehicleID(playerid);//get the players vehicleid
	GetVehicleVelocity(vehid,fvar[0],fvar[1],fvar[2]);//get the players X speed, Y speed and Z speed
	GetVehicleZAngle(vehid,fvar[7]);//get the players vehicle Z angle
	if(Drift_VAR[playerid][NitroLeft] < 0)//if nitro is below 0
	{
	    Drift_VAR[playerid][NitroLeft] = 0;//set to 0
		Drift_VAR[playerid][using] = false;//player is not using it because...
		RemoveVehicleComponent(vehid,1010);//...we remove it
 	}
 	
 	new Float:Xtemp = floatmul(floatdiv(Drift_VAR[playerid][NitroLeft],MAX_NITRO),100.0);
 	new AmountView = floatround(Xtemp);

	s[0] = 0;
	for(new i = 0; i < AmountView; ++i)
	{
		strins(s,"/",0);
	}
 	TextDrawSetString(Textdraw9[playerid],s);

	new Float:Angle = RealDifference(fvar[7],GetVelocityHeading(fvar[0],fvar[1],fvar[7]));//now we calculate his difference between his heading and his angle
	new Float:Speed = floatsqroot((fvar[0]*fvar[0])+(fvar[1]*fvar[1])+(fvar[2]*fvar[2]))*274.0;//calculate players speed
	format(s,255,"%.0f km/h~n~_____%.0f",Speed,Angle);//format our nice string and...
	TextDrawSetString(Textdraw6[playerid],s);//...update our speedo and driftmeter textdraw
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)//yay, player does something, we actually need to monitor
{
	if(oldstate == PLAYER_STATE_DRIVER)//the player was a driver so...
	{
	//hide all TD's
		TextDrawHideForPlayer(playerid, Textdraw0[playerid]);
		TextDrawHideForPlayer(playerid, Textdraw1[playerid]);
		TextDrawHideForPlayer(playerid, Textdraw2[playerid]);
		TextDrawHideForPlayer(playerid, Textdraw3[playerid]);

		TextDrawHideForPlayer(playerid, Textdraw4[playerid]);
		TextDrawHideForPlayer(playerid, Textdraw5[playerid]);
		TextDrawHideForPlayer(playerid, Textdraw6[playerid]);
		
		TextDrawHideForPlayer(playerid, Textdraw7[playerid]);
		
		TextDrawHideForPlayer(playerid, Textdraw8[playerid]);
		TextDrawHideForPlayer(playerid, Textdraw9[playerid]);
	}
	if(newstate == PLAYER_STATE_DRIVER)//and the players new state is a driver (also?) so
	{
	//we show the TD's and do a little scoreboard update
		TextDrawShowForPlayer(playerid, Textdraw0[playerid]);
		TextDrawShowForPlayer(playerid, Textdraw1[playerid]);
		TextDrawShowForPlayer(playerid, Textdraw2[playerid]);
		TextDrawShowForPlayer(playerid, Textdraw3[playerid]);
		
		TextDrawShowForPlayer(playerid, Textdraw4[playerid]);
		TextDrawShowForPlayer(playerid, Textdraw5[playerid]);
		TextDrawShowForPlayer(playerid, Textdraw6[playerid]);

		TextDrawShowForPlayer(playerid, Textdraw8[playerid]);
		TextDrawShowForPlayer(playerid, Textdraw9[playerid]);

		format(s,255,"Best:~Y~%d~N~~N~~N~~N~~W~Score:~R~%d",Drift_VAR[playerid][Best],Drift_VAR[playerid][Score]);
		TextDrawSetString(Textdraw1[playerid],s);
    	TextDrawSetString(Textdraw3[playerid],"Gain ~G~X2~W~ with:~N~_______350");
    	TextDrawSetString(Textdraw2[playerid],"~G~X1");
	}
	return 1;
}

//calculation functions.. maths etc
forward Float:RealDifference(Float:A,Float:H);
stock Float:RealDifference(Float:A,Float:H)//Get smallest difference
{
	new Float:diff = H-A;
	if(diff < -180.0)diff+=360.0;
	if(diff > 180.0)diff-=360.0;
	return floatabs(diff);
}

forward Float:GetVelocityHeading(Float:Vx,Float:Vy,Float:VZA);
stock Float:GetVelocityHeading(Float:Vx,Float:Vy,Float:VZA)//Get heading angle
{
	if(Vy == 0.0)
		Vy = 0.0000000001;//prevent division by 0
	if(Vx < 0 < Vy)
		return 0   - atan(Vx/Vy);
	else if((Vx < 0 > Vy) || (Vx > 0 > Vy))
		return 180 - atan(Vx/Vy);
	else if(Vx > 0 < Vy)
		return 360 - atan(Vx/Vy);
	else
	    return VZA;//we have no speed in X, so the players angle can't be determined, in this case we return the vehicle angle instead of the heading which can't be determined
}
