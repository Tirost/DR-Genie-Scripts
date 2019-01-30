
if_1 goto %1

MM:
put #subs {^In the chapter entitled.*(Invocation of the Spheres \[iots\]|Artificer's Eye \[ART\]|Aura Sight \[AUS\]|Clear Vision \[cv\]|Machinist's Touch \[mt\]|Saesordian Compass \[sco\]|Shadows(?=,| spells?)|Tenebrous Sense \[ts\])} {$1 (augmentation)} {MM}
put #subs {^In the chapter entitled.*(Calm(?=,| spells?)|Dazzle(?=,| spells?)|Mental Blast \[mb\]|Sleep(?=,| spells?)|Sovereign Destiny \[sod\]|Sever Thread \[set\]|Mind Shout \[ms\])} {$1 (debilitation)} {MM}
put #subs {^In the chapter entitled.*(Dinazen Olkar \[do\]|Starlight Sphere \[sls\]|Telekinetic Storm \[tks\]|Partial Displacement \[pd\]|Telekinetic Throw \[tkt\]|Burn(?=,| spells?))} {$1 (TM)} {MM}
put #subs {^In the chapter entitled.*(Moonblade(?=,| spells?)|Moongate \[mg\]|Braun's Conjecture \[bc\]|Destiny Cipher \[dc\]|Read the Ripples \[rtr\]|Contingency(?=,| spells?|Distant Gaze \[dg\]|Focus Moonbeam \[fm\]|Locate(?=,| spells?)|Piercing Gaze \[pg\]|Refractive Field \[rf\]|Riftal Summons \[rs\]|Shadewatch Mirror \[shm\]|Shadow Servant \[ss\]|Shift Moonbeam \[sm\]|Teleport(?=,| spells?)|Thoughtcast \[th\]|Unleash(?=,| spells?)|Shadowling(?=,| spells?)|Steps of Vuan \[sov\])} {$1 (utility)} {MM}
put #subs {^In the chapter entitled.*(Psychic Shield \[psy\]|Shear(?=,| spells?)|Whole Displacement \[wd\]|Cage of Light \[col\])} {$1 (warding)} {MM}
put #subs {^In the chapter entitled.*(Seer's Sense \[seer\])} {$1 (aug/utility)} {MM}
put #subs {^In the chapter entitled.*(Tezirah's Veil \[tv\])} {$1 (aug/debil)} {MM}
put #subs {^In the chapter entitled.*(Rend(?=,| spells?)|Tangled Fate \[tf\])} {$1 (debil/utility} {MM}
put #subs {^In the chapter entitled.*(Empower Moonblade \[emmo\]|Hypnotize(?=,| spells?)|Shape Moonblade \[shmo\])} {$1 (meta)} {MM}
if_1 exit

Trader:
put #subs {^In the chapter entitled.*(Blur(?=,| spells?)|Enrichment(?=,| spells?)|Finesse \[fin\]|Last Gift of Vithwok IV \[lgv\]|Membrach's Greed \[meg\]|Platinum Hands of Kertigen \[phk\]|Turmar Illumination \[turi\])} {$1 (augmentation)} {Trader}
put #subs {^In the chapter entitled.*(Fluoresce \[flu\])} {$1 (debilitation)} {Trader}
put #subs {^In the chapter entitled.*(Arbiter's Stylus \[ars\]|Crystal Dart \[crd\]|Starcrash \[star\]))} {$1 (TM)} {Trader}
put #subs {^In the chapter entitled.*(Noumena \[nou\]|Regalia \[rega\]|Stellar Collector \[stc\])} {$1 (utility)} {Trader}
put #subs {^In the chapter entitled.*(Elision \[eli\]|Mask of the Moons \[mom\]|Nonchalance \[non\]|Trabe Chalice \[trc\])} {$1 (warding)} {Trader}
put #subs {^In the chapter entitled.*(Avren Aevareae \[ava\])} {$1 (aug/debil)} {Trader}
put #subs {^In the chapter entitled.*(Avtalia Array \[avta\]|Bespoke Regalia(?=,| spells?)|Resumption \[resum\])} {$1 (meta)} {Trader}
if_1 exit

Empath:
put #subs {^In the chapter entitled.*(Agressive Stance \[ags\]|Gift of Life \[gol\]|Mental Focus \[mef\]|Refresh(?:,| spells?)|Vigor(?=,| spells?))} {$1 (augmentation)} {Empath}
put #subs {^In the chapter entitled.*(Compel(?=,| spells?)|Lethargy(?=,| spells?)|Nissa's Binding \[nb\])} {$1 (debilitation)} {Empath}
put #subs {^In the chapter entitled.*(Icutu Zaharenela \[iz\]|Paralysis(?=,| spells?))} {$1 (TM) {Empath}
put #subs {^In the chapter entitled.*(Absolution(?=,| spells?)|Awaken \[awaken\]|Blood Staunching \[bs\]|Circle of Sympathy \[cos\]|Cure Disease \[cd\]|Flush Poisons \[fp\]|Fountain of Creation \[foc\]|Guardian Spirit \[gs\]|Heal(?=,| spells?)|Heal Scars \[hs\]|Heal Wounds \[hw\]|Heart Link \[hl\]|Innocence(?=,| spells?)|Regenerate(?=,| spells?)|Vitality Healing \[vh\]|Raise Power \[rp\])} {$1 (utility)} {Empath}
put #subs {^In the chapter entitled.*(Iron Constitution \[ic\]|Perseverance of Peri'el \[pop\])} {$1 (warding)} {Empath}
put #subs {^In the chapter entitled.*(Aesandry Darlaeth \[ad\])} {$1 (aug/utility)} {Empath}
put #subs {^In the chapter entitled.*(Tranquility(?=,| spells?)} {$1 (aug/warding)} {Empath}
put #subs {^In the chapter entitled.*(Adaptive Curing \[adc\])} {$1 (meta)} {Empath}
if_1 exit

Ranger:
put #subs {^In the chapter entitled.*(Athleticism(?=,|spells?)Cheetah Swiftness \[cs\]|Claws of the Cougar \[cotc\]|Hands of Lirisa \[hol\]|Instinct \[inst\]|Oath of the Firstborn \[oath\]|See the Wind \[stw\]|Senses of the Tiger \[sott\]|Wisdom of the Pack \[wotp\]|Wolf Scent \[ws\])} {$1 (augmentation)} {Ranger}
put #subs {^In the chapter entitled.*(Curse of the Wilds \[cotw\]|Deadfall \[df\]|Devolve \[de\]|Grizzly Claws \[griz\]|Harawep's Bonds \[hb\]|Swarm(?=,| spells?))} {$1 (debilitation)} {Ranger}
put #subs {^In the chapter entitled.*(Carrion Call \[cac\]|Devitalize \[devi\]|Eagle's Cry \[ec\]|Stampede(?=,| spells?))} {$1 (TM) {Ranger}
put #subs {^In the chapter entitled.*(Awaken Forest \[af\]|Blend(?=,| spells?)|Memory of Nature \[mon\]|Compost(?=,| spells?))} {$1 (utility)} {Ranger}
put #subs {^In the chapter entitled.*(Essence of Yew \[ey\]|Forestwalker's Boon \[fwb\])} {$1 (warding)} {Ranger}
put #subs {^In the chapter entitled.*(Bear Strength \[bes\]|Earth Meld \[em\]|Skein of Shadows \[sks\])} {$1 (aug/utility)} {Ranger}
put #subs {^In the chapter entitled.*(Plague of Scavengers \[pls\])} {$1 (meta)} {Ranger}
if_1 exit

Cleric:
put #subs {^In the chapter entitled.*(Auspice(?=,| spells?)|Benediction(?=,| spells)|Centering(?=,| spells?)|Glythtide's Gift \[gg\]|Major Phyiscal Protection \[mapp\]|Persistence of Mana \[pom\]|Sanctify Pattern \[sap\])} {$1 (augmentation)} {Cleric}
put #subs {^In the chapter entitled.*(Curse of Zachriedek \[coz\]|Huldah's Pall \[hulp\]|Hydra Hex \[hyh\]|Malediction \[male\]|Meraud's Cry \[mc\]|Phelim's Sanction \[ps\]|Soul Bonding \[sb\]|Soul Sickness \[sick\])} {$1 (debilitation)} {Cleric}
put #subs {^In the chapter entitled.*(Chill Spirit \[chs\]|Hand of Tenemlor \[hot\]|Horn of the Unicorn \[horn\]|Fire of Ushnish \[fou\]|Harm Horde \[hh\]|Fist of Faenella \[ff\]|Aesrela Everild \[ae\]|Soul Attrition \[sa\]|Harm Evil \[he\])} {$1 (TM) {Cleric}
put #subs {^In the chapter entitled.*(Eylhaar's Feast \[ef\]|Uncurse(?=,| spells?)|Resurrection \[rezz\]|Murrula's Flames \[mf\]|Bless(?=,| spells?)|Divine Radiance \[dr\]|Osrel Meraud \[om\]|Rejuvenation \[rejuv\]|Vigil(?=,| spells?)|Mass Rejuvenation \[mre\])} {$1 (utility)} {Cleric}
put #subs {^In the chapter entitled.*(Sanyu Lyba \[sl\]|Ghost Shroud \[ghs\]|Minor Physical Protection \[mpp\]|Major Physical Protection \[mapp\]|Protection from Evil \[pfe\]|Soul Shield \[sos\])} {$1 (warding)} {Cleric}
put #subs {^In the chapter entitled.*(Aspects of the All-God \[all\]|Revelation \[rev\]|Shield of Light \[sol\])} {$1 (aug/utility)} {Cleric}
put #subs {^In the chapter entitled.*(Halo(?=,| spells?)|Spite of Dergati \[spit\])} {$1 debil/warding} {Cleric}
put #subs {^In the chapter entitled.*(Idon's Theft \[it\])} {$1 debil/utility} {Cleric}
put #subs {^In the chapter entitled.*(Bitter Feast|Time of the Red Spiral \[totrs\]||Heavenly Fires \[hf\])} {$1 (meta)} {Cleric}
if_1 exit

Paladin:
put #subs {^In the chapter entitled.*(Clarity(?=,| spells?)|Courage(?=,| spells?)|Divine Guidance \[dig\]|Heroic Strength \[hes\]|Marshal Order \[mo\]|Righteous Wrath \[rw\]|Sentinel's Resolve \[sr\]} {$1 (augmentation)} {Paladin}
put #subs {^In the chapter entitled.*(Halt(?=,| spells?)|Shatter(?=,| spells?)|Stun Foe \[sf\])} {$1 (debilitation)} {Paladin}
put #subs {^In the chapter entitled.*(Footman's Strike \[fst\]|Smite Horde \[smh\]|Rebuke \[reb\])} {$1 (TM) {Paladin}
put #subs {^In the chapter entitled.*(Alamhif's Gift \[ag\]|Anti-Stun \[as\]|Banner of Truce \[bot\]|Bond Armaments \[ba\]|Divine Armor \[da\]|Hands of Justice \[hoj\]|Rutilor's Edge \[rue\]|Vessel of Salvation \[vos\])} {$1 (utility)} {Paladin}
put #subs {^In the chapter entitled.*(Aspirant's Aegis \[aa\]|Soldier's Prayer \[sp\])} {$1 (warding)} {Paladin}
put #subs {^In the chapter entitled.*(Crusader's Challenge \[crc\]|Truffenyi's Rally \[tr\])} {$1 (aug/utility)} {Paladin}
put #subs {^In the chapter entitled.*(Holy Warrior \[how\]) {$1 utility/warding} {Paladin}
put #subs {^In the chapter entitled.*(Veteran Insight \[veteran\])} {$1 (meta)} {Paladin}
if_1 exit

Bard:
put #subs {^In the chapter entitled.*(Blessing of the Fae \[botf\]|Drums of the Snake \[drum\]|Echoes of Aether \[echo\]|Ellie's Cry \[ecry\]|Faenella's Grace \[fae\]|Harmony \[harm\]|Rage of the Clans \[rage\]|Soul Ablaze \[soul\]|Whispers of the Muse \[wotm\]|Will of Winter \[will\]|Words of the Wind \[word\])} {$1 (augmentation)} {Bard}
put #subs {^In the chapter entitled.*(Aether Wolves \[aewo\]|Damaris' Lullaby \[dalu\]|Demrris' Resolve \[dmrs\]|Desert's Maelstrom \[dema\])} {$1 (debilitation)} {Bard}
put #subs {^In the chapter entitled.*(Breath of Storms \[bos\]|Abandoned Heart \[aban\]|Phoenix's Pyre \[pyre\]|Beckon the Naga \[btn\])} {$1 (TM) {Bard}
put #subs {^In the chapter entitled.*(Aura of Tongues \[aot\]|Caress of the Sun \[care\]|Eye of Kertigen \[eye\]|Hodierna's Lilt \[hodi\]|Nexus(?=,| spells?)Resonance(?=,| spells?)|Sanctuary(?=,| spells?)} {$1 (utility)} {Bard}
put #subs {^In the chapter entitled.*(Glythtide's Joy \[gj\]|Naming of Tears \[name\]|Redeemer's Pride \[repr\])} {$1 (warding)} {Bard}
put #subs {^In the chapter entitled.*(Misdirection \[mis\])} {$1 (aug/debil)} {Bard}
put #subs {^In the chapter entitled.*(Albreda's Balm \[alb\])} {$1 debil/utility} {Bard}
if_1 exit

WM:
put #subs {^In the chapter entitled.*(Aegis of Granite \[aeg\]|Mantle of Flame \[mof\]|Substratum(?=,| spells?)|Sure Footing \[suf\]|Swirling Winds \[sw\]|Tailwind \[tw\]|Y'ntrel Sechra \[ys\])} {$1 (augmentation)} {WM}
put #subs {^In the chapter entitled.*(Anther's Call \[anc\]|Arc Light \[al\]|Electrostatic Eddy \[ee\]|Frostbite(?=,| spells?)|Ice Patch \[ip\]|Mark of Arhat \[moa\]|Thunderclap \[tc\]|Tingle \[ti\]|Tremor \[trem\]|Vertigo(?=,| spells?)|Ward Break \[wb\])} {$1 (debilitation)} {WM}
put #subs {^In the chapter entitled.*(Aethrolysis(?=,| spells?)|Air Lash \[ala\]|Geyser(?=,| spells?|Magnetic Ballista \[mab\]|Paeldryth's Wrath \[pw\]|Chain Lightning \[cl\]|Shockwave(?=,| spells?)|Fire Rain \[fr\]|Ring of Spears \[ros\]|Fire Ball \[fb\]|Dragon's Breath \[db\]|Blufmor Garaen \[bg\]|Fire Shards \[fs\]|Gar Zeng \[gz\]|Stone Strike \[sts\]|Rimefang \[rim\]|Lightning Bolt \[lb\])} {$1 (TM) {WM}
put #subs {^In the chapter entitled.*(Air Bubble \[ab\]|Ethereal Fissure \[etf\]|Fortress of Ice \[foi\]|Ignite(?=,| spells?)|Rising Mists \[rm\]|Zephyr(?=,| spells?))} {$1 (utility)} {WM}
put #subs {^In the chapter entitled.*(Aether Cloak \[ac\]|Ethereal Shield \[es\]|Grounding Field \[gf\]|Veil of Ice \[voi\])} {$1 (warding)} {WM}
put #subs {^In the chapter entitled.*(Elementalism(?=,| spells?)|Flame Shockwave \[fls\]|Infusions(?=,| spells?)|)} {$1 (meta)} {WM}
if_1 exit

Necro:
put #subs {^In the chapter entitled.*(Butcher's Eye \[bue\]|Ivory Mask \[ivm\]|Kura-Silma \[ks\]|Obfuscation(?=,| spells?)|Philosopher's Preservation \[php\]|Researchrer's Insight \[rei\]|Reverse Putrefaction \[rpu\]|)} {$1 (augmentation)} {Necro}
put #subs {^In the chapter entitled.*(Petrifying Visions \[pv\]|Viscous Solution \[vs\]|Visions of Darkness \[vod\])} {$1 (debilitation)} {Necro}
put #subs {^In the chapter entitled.*(Acid Splash \[acs\]|Blood Burst \[blb\]|Siphon Vitality \[sv\]|Vivisection(?=,| spells?)|Universal Solvent \[usol\])} {$1 (TM) {Necro}
put #subs {^In the chapter entitled.*(Call from Beyond \[cfb\]|Consume Flesh \[cf\]|Devour(?=,| spells?)|Eyes of the Blind \[eotb\]|Necrotic Reconstruction \[nr\]|Quicken the Earth \[qe\]|Rite of Contrition \[roc\]|Rite of Grace \[rog\])} {$1 (utility)} {Necro}
put #subs {^In the chapter entitled.*(Calcified Hide \[ch\]|Worm's Mist \[worm\])} {$1 (warding)} {Necro}
put #subs {^In the chapter entitled.*(Alkahest Edge(?=,| spells?)|Chirurgia \[chir\]|Covetous Rebirt \[cre\]|Liturgy(?=,| spells?)|Spiteful Rebirth \[sre\])} {$1 (meta)} {Necro}
if_1 exit

AP:
put #subs {^In the chapter entitled.*(Ease Burden \[ease\])} {$1 (augmentation)}
put #subs {^In the chapter entitled.*(Burden(?=,| spells?)} {$1 (debilitation)}
put #subs {^In the chapter entitled.*(Strange Arrow \[stra\])} {$1 (TM)
put #subs {^In the chapter entitled.*(Dispel(?=,| spells?)|Gauge Flow \[gaf\]|Imbue(?=,| spells?)|Seal Cambrinth \[sec\])} {$1 (utility)}
put #subs {^In the chapter entitled.*(Lay Ward \[lw\]|Manifest Force \[maf\])} {$1 (warding)}
if_1 exit