var/global/default_martial_art = new/datum/martial_art
/mob/living/carbon/human

	hud_possible = list(HEALTH_HUD,STATUS_HUD,ID_HUD,WANTED_HUD,IMPLOYAL_HUD,IMPCHEM_HUD,IMPTRACK_HUD,SPECIALROLE_HUD,NATIONS_HUD)

	//Marking colour and style
	var/r_markings = 0
	var/g_markings = 0
	var/b_markings = 0
	var/m_style = "None"

	//Eye colour
	var/r_eyes = 0
	var/g_eyes = 0
	var/b_eyes = 0

	var/s_tone = 0	//Skin tone

	w_class = 8

	//Skin colour
	var/r_skin = 0
	var/g_skin = 0
	var/b_skin = 0

	var/lip_style = null	//no lipstick by default- arguably misleading, as it could be used for general makeup
	var/lip_color = "white"

	age = 30		//Player's age (pure fluff)
	var/b_type = "A+"	//Player's bloodtype
	// 	var/underwear = "Nude"	//Which underwear the player wants
	//	var/undershirt = "Nude"	//Which undershirt the player wants
	var/socks = "Nude" //Which socks the player wants
	var/backbag = 2		//Which backpack type the player has chosen. Nothing, Satchel or Backpack.

	map_storage_saved_vars = "name;real_name;r_markings;g_markings;b_markings;m_style;r_eyes;g_eyes;b_eyes;s_tone;r_skin;g_skin;b_skin;lip_style;lip_color;age;b_type;w_uniform;shoes;belt;gloves;glasses;l_ear;r_ear;wear_id;wear_pda;r_store;l_store;s_store;undewear;undershirt;head;toxloss;oxyloss;cloneloss;brainloss;internal_organs;organs;age;wear_mask;wear_suit;dna;species;back;gender;r_hand;l_hand;flavor_text"
	//Equipment slots
	var/obj/item/w_uniform = null
	var/obj/item/shoes = null
	var/obj/item/belt = null
	var/obj/item/gloves = null
	var/obj/item/glasses = null
	var/obj/item/l_ear = null
	var/obj/item/r_ear = null
	var/obj/item/wear_id = null
	var/obj/item/wear_pda = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/obj/item/s_store = null
	var/obj/item/underwear = null
	var/obj/item/undershirt = null
	var/icon/stand_icon = null
	var/icon/lying_icon = null

	var/voice = ""	//Instead of new say code calling GetVoice() over and over and over, we're just going to ask this variable, which gets updated in Life()

	var/speech_problem_flag = 0

	var/datum/personal_crafting/handcrafting

	var/datum/martial_art/martial_art = null

	var/special_voice = "" // For changing our voice. Used by a symptom.
	var/said_last_words=0

	var/last_dam = -1	//Used for determining if we need to process all organs or just some or even none.
	var/list/bad_external_organs = list()// organs we check until they are good.

	var/hand_blood_color

	var/name_override //For temporary visible name changes

	var/xylophone = 0 //For the spoooooooky xylophone cooldown

	var/mob/remoteview_target = null
	var/meatleft = 3 //For chef item
	var/decaylevel = 0 // For rotting bodies
	var/max_blood = BLOOD_VOLUME_NORMAL // For stuff in the vessel
	var/slime_color = "blue" //For slime people this defines their color, it's blue by default to pay tribute to the old icons

	var/check_mutations=0 // Check mutations on next life tick

	var/lastFart = 0 // Toxic fart cooldown.

	var/fire_dmi = 'icons/mob/OnFire.dmi'
	var/fire_sprite = "Standing"

	var/datum/body_accessory/body_accessory = null
/mob/living/carbon/human/after_load()
	if(back)
		equip_to_slot(back,slot_back)
	if(wear_mask)
		equip_to_slot(wear_mask, slot_wear_mask)
	if(handcuffed)
		equip_to_slot(handcuffed, slot_handcuffed)
	if(legcuffed)
		equip_to_slot(legcuffed, slot_legcuffed)
	if(l_hand)
		equip_to_slot(l_hand, slot_l_hand)
	if(r_hand)
		equip_to_slot(r_hand, slot_r_hand)
	if(belt)
		equip_to_slot(belt, slot_belt)
	if(wear_id)
		equip_to_slot(wear_id, slot_wear_id)
	if(wear_pda)
		equip_to_slot(wear_pda, slot_wear_pda)
	if(l_ear)
		equip_to_slot(l_ear, slot_l_ear)
	if(r_ear)
		equip_to_slot(r_ear, slot_r_ear)
	if(glasses)
		equip_to_slot(glasses, slot_glasses)
	if(gloves)
		equip_to_slot(gloves, slot_gloves)
	if(head)
		equip_to_slot(head, slot_head)
	if(shoes)
		equip_to_slot(shoes, slot_shoes)
	if(wear_suit)
		equip_to_slot(wear_suit, slot_wear_suit)
	if(w_uniform)
		equip_to_slot(w_uniform, slot_w_uniform)
	if(l_store)
		equip_to_slot(l_store, slot_l_store)
	if(r_store)
		equip_to_slot(r_store, slot_r_store)
	if(s_store)
		equip_to_slot(s_store,slot_s_store)
	if(underwear)
		equip_to_slot(underwear,slot_underwear)
	if(undershirt)
		equip_to_slot(undershirt,slot_undershirt)

	var/mob/living/carbon/human/character = src
	if(organs && !isemptylist(organs))
		for(var/obj/item/organ/external/O in organs)
			O.owner = character
			if(istype(O, /obj/item/organ/external/chest))
				character.organs_by_name["chest"] = O
			else if(istype(O, /obj/item/organ/external/groin))
				character.organs_by_name["groin"] = O
			else if(istype(O, /obj/item/organ/external/arm/right))
				character.organs_by_name["r_arm"] = O
			else if(istype(O, /obj/item/organ/external/arm))
				character.organs_by_name["l_arm"] = O
			else if(istype(O, /obj/item/organ/external/leg/right))
				character.organs_by_name["r_leg"] = O
			else if(istype(O, /obj/item/organ/external/leg))
				character.organs_by_name["l_leg"] = O
			else if(istype(O, /obj/item/organ/external/foot/right))
				character.organs_by_name["r_foot"] = O
			else if(istype(O, /obj/item/organ/external/foot))
				character.organs_by_name["l_foot"] = O
			else if(istype(O, /obj/item/organ/external/hand/right))
				character.organs_by_name["r_hand"] = O
			else if(istype(O, /obj/item/organ/external/hand))
				character.organs_by_name["l_hand"] = O
			else if(istype(O, /obj/item/organ/external/head))
				character.organs_by_name["head"] = O
	if(internal_organs && !isemptylist(internal_organs))
		var/list/emptyorgans = list()
		for(var/obj/item/organ/internal/O in internal_organs)
			O.owner = character
			O.insert(character)
			var/obj/item/organ/external/parent = get_organ(check_zone(O.parent_organ))
			if(parent && (isemptylist(parent.internal_organs) || emptyorgans.Find(O.parent_organ)))
				emptyorgans |= O.parent_organ
				parent.internal_organs |= O
	domutcheck(src)
	UpdateAppearance()
	update_eyes()
	regenerate_icons()
	SpeciesFix()
	..()