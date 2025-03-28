clear all;

cd 'C:\Users\oporteous\Documents\Data'

%processing tau file
[at,bt,ct] = xlsread('tauest2.xlsx');
[dt et] = size(at);
[ft gt] = size(bt);
tauout1 = bt(2:ft,1:4);
tauout2 = zeros(dt,3);
tauout2(1:dt,1) = at(1:dt,1);
tauout2(1:dt,2) = at(1:dt,6);
tauout2(1:dt,3) = at(1:dt,11);
tauout3 = num2cell(tauout2);
fid = fopen('tauest2.csv','wt');
if fid>0
    for k=1:size(tauout1,1)
        fprintf(fid,'%s,%s,%s,%s,',tauout1{k,:});
        fprintf(fid,'%f,%f,%f\n',tauout3{k,:});
    end
    fclose(fid);
end

%now on to rk
[a,b,c] = xlsread('rkest4.xlsx');
pdat = a;
[d e] = size(b);
pmkt = b(2:d,1);
pcrp = b(2:d,2);

sz = size(pdat);
helper = isnan(pdat);
for i=1:sz(1,1);
    for j=1:132;
        if helper(i,j)==1;
            pdat(i,j)=0;
        end;
    end;
end;

pdat2 = pdat(1:sz(1,1),13:132);

%id has 2 columns, market id and crop id
id = zeros(sz(1,1),2);
for i=1:sz(1,1);
if strcmp(pmkt(i,1),'Gaborone')==1; id(i,1) = 110; end;
if strcmp(pmkt(i,1),'Kalemie')==1; id(i,1) = 121; end;
if strcmp(pmkt(i,1),'Kamina')==1; id(i,1) = 122; end;
if strcmp(pmkt(i,1),'Kolwezi')==1; id(i,1) = 123; end;
if strcmp(pmkt(i,1),'Lubumbashi')==1; id(i,1) = 124; end;
if strcmp(pmkt(i,1),'Maseru')==1; id(i,1) = 130; end;
if strcmp(pmkt(i,1),'Blantyre')==1; id(i,1) = 140; end;
if strcmp(pmkt(i,1),'Karonga')==1; id(i,1) = 141; end;
if strcmp(pmkt(i,1),'Lilongwe')==1; id(i,1) = 142; end;
if strcmp(pmkt(i,1),'Mangochi')==1; id(i,1) = 143; end;
if strcmp(pmkt(i,1),'Mzuzu')==1; id(i,1) = 144; end;
if strcmp(pmkt(i,1),'Beira')==1; id(i,1) = 145; end;
if strcmp(pmkt(i,1),'Chimoio')==1; id(i,1) = 146; end;
if strcmp(pmkt(i,1),'Cuamba')==1; id(i,1) = 147; end;
if strcmp(pmkt(i,1),'Lichinga')==1; id(i,1) = 148; end;
if strcmp(pmkt(i,1),'Maputo')==1; id(i,1) = 149; end;
if strcmp(pmkt(i,1),'Maxixe')==1; id(i,1) = 150; end;
if strcmp(pmkt(i,1),'Milange')==1; id(i,1) = 151; end;
if strcmp(pmkt(i,1),'Nacala')==1; id(i,1) = 152; end;
if strcmp(pmkt(i,1),'Nampula')==1; id(i,1) = 153; end;
if strcmp(pmkt(i,1),'Pemba')==1; id(i,1) = 154; end;
if strcmp(pmkt(i,1),'Quelimane')==1; id(i,1) = 155; end;
if strcmp(pmkt(i,1),'Tete')==1; id(i,1) = 156; end;
if strcmp(pmkt(i,1),'XaiXai')==1; id(i,1) = 157; end;
if strcmp(pmkt(i,1),'KatimaMulilo')==1; id(i,1) = 160; end;
if strcmp(pmkt(i,1),'Oshakati')==1; id(i,1) = 161; end;
if strcmp(pmkt(i,1),'Swakopmund')==1; id(i,1) = 162; end;
if strcmp(pmkt(i,1),'Windhoek')==1; id(i,1) = 163; end;
if strcmp(pmkt(i,1),'Mbabane')==1; id(i,1) = 165; end;
if strcmp(pmkt(i,1),'Iringa')==1; id(i,1) = 170; end;
if strcmp(pmkt(i,1),'Mbeya')==1; id(i,1) = 171; end;
if strcmp(pmkt(i,1),'Mtwara')==1; id(i,1) = 172; end;
if strcmp(pmkt(i,1),'Songea')==1; id(i,1) = 173; end;
if strcmp(pmkt(i,1),'Sumbawanga')==1; id(i,1) = 174; end;
if strcmp(pmkt(i,1),'Chipata')==1; id(i,1) = 180; end;
if strcmp(pmkt(i,1),'Kabwe')==1; id(i,1) = 181; end;
if strcmp(pmkt(i,1),'Kasama')==1; id(i,1) = 182; end;
if strcmp(pmkt(i,1),'Kitwe')==1; id(i,1) = 183; end;
if strcmp(pmkt(i,1),'Livingstone')==1; id(i,1) = 184; end;
if strcmp(pmkt(i,1),'Lusaka')==1; id(i,1) = 185; end;
if strcmp(pmkt(i,1),'Mongu')==1; id(i,1) = 186; end;
if strcmp(pmkt(i,1),'Solwezi')==1; id(i,1) = 187; end;
if strcmp(pmkt(i,1),'Bulawayo')==1; id(i,1) = 190; end;
if strcmp(pmkt(i,1),'Harare')==1; id(i,1) = 191; end;
if strcmp(pmkt(i,1),'Hwange')==1; id(i,1) = 192; end;
if strcmp(pmkt(i,1),'Masvingo')==1; id(i,1) = 193; end;
if strcmp(pmkt(i,1),'Mutare')==1; id(i,1) = 194; end;
if strcmp(pmkt(i,1),'Luanda')==1; id(i,1) = 200; end;
if strcmp(pmkt(i,1),'Bujumbura')==1; id(i,1) = 201; end;
if strcmp(pmkt(i,1),'Gitega')==1; id(i,1) = 202; end;
if strcmp(pmkt(i,1),'Muyinga')==1; id(i,1) = 203; end;
if strcmp(pmkt(i,1),'Bambari')==1; id(i,1) = 210; end;
if strcmp(pmkt(i,1),'Bangassou')==1; id(i,1) = 211; end;
if strcmp(pmkt(i,1),'Bangui')==1; id(i,1) = 212; end;
if strcmp(pmkt(i,1),'Brazzaville')==1; id(i,1) = 213; end;
if strcmp(pmkt(i,1),'Impfondo')==1; id(i,1) = 214; end;
if strcmp(pmkt(i,1),'PointeNoire')==1; id(i,1) = 215; end;
if strcmp(pmkt(i,1),'Bandundu')==1; id(i,1) = 220; end;
if strcmp(pmkt(i,1),'Bukavu')==1; id(i,1) = 221; end;
if strcmp(pmkt(i,1),'Bunia')==1; id(i,1) = 222; end;
if strcmp(pmkt(i,1),'Butembo')==1; id(i,1) = 223; end;
if strcmp(pmkt(i,1),'Gbadolite')==1; id(i,1) = 224; end;
if strcmp(pmkt(i,1),'Goma')==1; id(i,1) = 225; end;
if strcmp(pmkt(i,1),'Isiro')==1; id(i,1) = 226; end;
if strcmp(pmkt(i,1),'Kananga')==1; id(i,1) = 227; end;
if strcmp(pmkt(i,1),'Kikwit')==1; id(i,1) = 228; end;
if strcmp(pmkt(i,1),'Kindu')==1; id(i,1) = 229; end;
if strcmp(pmkt(i,1),'Kinshasa')==1; id(i,1) = 230; end;
if strcmp(pmkt(i,1),'Kisangani')==1; id(i,1) = 231; end;
if strcmp(pmkt(i,1),'Matadi')==1; id(i,1) = 232; end;
if strcmp(pmkt(i,1),'Mbandaka')==1; id(i,1) = 233; end;
if strcmp(pmkt(i,1),'MbujiMayi')==1; id(i,1) = 234; end;
if strcmp(pmkt(i,1),'Tshikapa')==1; id(i,1) = 235; end;
if strcmp(pmkt(i,1),'Uvira')==1; id(i,1) = 236; end;
if strcmp(pmkt(i,1),'Zongo')==1; id(i,1) = 237; end;
if strcmp(pmkt(i,1),'Gode')==1; id(i,1) = 240; end;
if strcmp(pmkt(i,1),'Jijiga')==1; id(i,1) = 241; end;
if strcmp(pmkt(i,1),'Yabelo')==1; id(i,1) = 242; end;
if strcmp(pmkt(i,1),'Eldoret')==1; id(i,1) = 243; end;
if strcmp(pmkt(i,1),'Garissa')==1; id(i,1) = 244; end;
if strcmp(pmkt(i,1),'Kisumu')==1; id(i,1) = 245; end;
if strcmp(pmkt(i,1),'Lodwar')==1; id(i,1) = 246; end;
if strcmp(pmkt(i,1),'Mandera')==1; id(i,1) = 247; end;
if strcmp(pmkt(i,1),'Mombasa')==1; id(i,1) = 248; end;
if strcmp(pmkt(i,1),'Moyale')==1; id(i,1) = 249; end;
if strcmp(pmkt(i,1),'Nairobi')==1; id(i,1) = 250; end;
if strcmp(pmkt(i,1),'Nakuru')==1; id(i,1) = 251; end;
if strcmp(pmkt(i,1),'Wajir')==1; id(i,1) = 252; end;
if strcmp(pmkt(i,1),'Butare')==1; id(i,1) = 260; end;
if strcmp(pmkt(i,1),'Gisenyi')==1; id(i,1) = 261; end;
if strcmp(pmkt(i,1),'Kigali')==1; id(i,1) = 262; end;
if strcmp(pmkt(i,1),'Baidoa')==1; id(i,1) = 270; end;
if strcmp(pmkt(i,1),'Beledweyne')==1; id(i,1) = 271; end;
if strcmp(pmkt(i,1),'Bosaso')==1; id(i,1) = 273; end;
if strcmp(pmkt(i,1),'Galkayo')==1; id(i,1) = 274; end;
if strcmp(pmkt(i,1),'Garoowe')==1; id(i,1) = 275; end;
if strcmp(pmkt(i,1),'Hargeisa')==1; id(i,1) = 276; end;
if strcmp(pmkt(i,1),'Kismayo')==1; id(i,1) = 277; end;
if strcmp(pmkt(i,1),'Mogadishu')==1; id(i,1) = 278; end;
if strcmp(pmkt(i,1),'Juba')==1; id(i,1) = 279; end;
if strcmp(pmkt(i,1),'Arusha')==1; id(i,1) = 280; end;
if strcmp(pmkt(i,1),'Bukoba')==1; id(i,1) = 281; end;
if strcmp(pmkt(i,1),'DaresSalaam')==1; id(i,1) = 282; end;
if strcmp(pmkt(i,1),'Dodoma')==1; id(i,1) = 283; end;
if strcmp(pmkt(i,1),'Kigoma')==1; id(i,1) = 284; end;
if strcmp(pmkt(i,1),'Musoma')==1; id(i,1) = 285; end;
if strcmp(pmkt(i,1),'Mwanza')==1; id(i,1) = 286; end;
if strcmp(pmkt(i,1),'Singida')==1; id(i,1) = 287; end;
if strcmp(pmkt(i,1),'Tabora')==1; id(i,1) = 288; end;
if strcmp(pmkt(i,1),'Tanga')==1; id(i,1) = 289; end;
if strcmp(pmkt(i,1),'Arua')==1; id(i,1) = 290; end;
if strcmp(pmkt(i,1),'Gulu')==1; id(i,1) = 291; end;
if strcmp(pmkt(i,1),'Jinja')==1; id(i,1) = 292; end;
if strcmp(pmkt(i,1),'Kampala')==1; id(i,1) = 293; end;
if strcmp(pmkt(i,1),'Lira')==1; id(i,1) = 294; end;
if strcmp(pmkt(i,1),'Masindi')==1; id(i,1) = 295; end;
if strcmp(pmkt(i,1),'Mbarara')==1; id(i,1) = 296; end;
if strcmp(pmkt(i,1),'Djibouti')==1; id(i,1) = 301; end;
if strcmp(pmkt(i,1),'Asmara')==1; id(i,1) = 302; end;
if strcmp(pmkt(i,1),'Massawa')==1; id(i,1) = 303; end;
if strcmp(pmkt(i,1),'AddisAbaba')==1; id(i,1) = 310; end;
if strcmp(pmkt(i,1),'Awasa')==1; id(i,1) = 312; end;
if strcmp(pmkt(i,1),'BahirDar')==1; id(i,1) = 313; end;
if strcmp(pmkt(i,1),'Dessie')==1; id(i,1) = 314; end;
if strcmp(pmkt(i,1),'DireDawa')==1; id(i,1) = 315; end;
if strcmp(pmkt(i,1),'Gambela')==1; id(i,1) = 316; end;
if strcmp(pmkt(i,1),'Gondar')==1; id(i,1) = 317; end;
if strcmp(pmkt(i,1),'Jimma')==1; id(i,1) = 318; end;
if strcmp(pmkt(i,1),'Mekele')==1; id(i,1) = 319; end;
if strcmp(pmkt(i,1),'Nekemte')==1; id(i,1) = 320; end;
if strcmp(pmkt(i,1),'Bor')==1; id(i,1) = 331; end;
if strcmp(pmkt(i,1),'Malakal')==1; id(i,1) = 332; end;
if strcmp(pmkt(i,1),'Rumbek')==1; id(i,1) = 333; end;
if strcmp(pmkt(i,1),'Wau')==1; id(i,1) = 334; end;
if strcmp(pmkt(i,1),'AdDamazin')==1; id(i,1) = 340; end;
if strcmp(pmkt(i,1),'AlFashir')==1; id(i,1) = 341; end;
if strcmp(pmkt(i,1),'AlQadarif')==1; id(i,1) = 342; end;
if strcmp(pmkt(i,1),'ElGeneina')==1; id(i,1) = 343; end;
if strcmp(pmkt(i,1),'ElObeid')==1; id(i,1) = 344; end;
if strcmp(pmkt(i,1),'Kadugli')==1; id(i,1) = 345; end;
if strcmp(pmkt(i,1),'Kassala')==1; id(i,1) = 346; end;
if strcmp(pmkt(i,1),'Khartoum')==1; id(i,1) = 347; end;
if strcmp(pmkt(i,1),'Kosti')==1; id(i,1) = 348; end;
if strcmp(pmkt(i,1),'Nyala')==1; id(i,1) = 349; end;
if strcmp(pmkt(i,1),'PortSudan')==1; id(i,1) = 350; end;
if strcmp(pmkt(i,1),'Cotonou')==1; id(i,1) = 401; end;
if strcmp(pmkt(i,1),'Malanville')==1; id(i,1) = 402; end;
if strcmp(pmkt(i,1),'Natitingou')==1; id(i,1) = 403; end;
if strcmp(pmkt(i,1),'Parakou')==1; id(i,1) = 404; end;
if strcmp(pmkt(i,1),'BoboDioulasso')==1; id(i,1) = 405; end;
if strcmp(pmkt(i,1),'Dedougou')==1; id(i,1) = 406; end;
if strcmp(pmkt(i,1),'FadaNgourma')==1; id(i,1) = 407; end;
if strcmp(pmkt(i,1),'Ouagadougou')==1; id(i,1) = 408; end;
if strcmp(pmkt(i,1),'Bamenda')==1; id(i,1) = 410; end;
if strcmp(pmkt(i,1),'Douala')==1; id(i,1) = 411; end;
if strcmp(pmkt(i,1),'Garoua')==1; id(i,1) = 412; end;
if strcmp(pmkt(i,1),'Yaounde')==1; id(i,1) = 413; end;
if strcmp(pmkt(i,1),'Abeche')==1; id(i,1) = 414; end;
if strcmp(pmkt(i,1),'Moundou')==1; id(i,1) = 415; end;
if strcmp(pmkt(i,1),'Ndjamena')==1; id(i,1) = 416; end;
if strcmp(pmkt(i,1),'Sarh')==1; id(i,1) = 417; end;
if strcmp(pmkt(i,1),'Abengourou')==1; id(i,1) = 420; end;
if strcmp(pmkt(i,1),'Abidjan')==1; id(i,1) = 421; end;
if strcmp(pmkt(i,1),'Bouake')==1; id(i,1) = 422; end;
if strcmp(pmkt(i,1),'Daloa')==1; id(i,1) = 423; end;
if strcmp(pmkt(i,1),'Man')==1; id(i,1) = 424; end;
if strcmp(pmkt(i,1),'Odienne')==1; id(i,1) = 425; end;
if strcmp(pmkt(i,1),'Libreville')==1; id(i,1) = 426; end;
if strcmp(pmkt(i,1),'Banjul')==1; id(i,1) = 427; end;
if strcmp(pmkt(i,1),'Accra')==1; id(i,1) = 428; end;
if strcmp(pmkt(i,1),'Bolgatanga')==1; id(i,1) = 429; end;
if strcmp(pmkt(i,1),'Ho')==1; id(i,1) = 430; end;
if strcmp(pmkt(i,1),'Kumasi')==1; id(i,1) = 431; end;
if strcmp(pmkt(i,1),'SekondiTakoradi')==1; id(i,1) = 432; end;
if strcmp(pmkt(i,1),'Tamale')==1; id(i,1) = 433; end;
if strcmp(pmkt(i,1),'Wa')==1; id(i,1) = 434; end;
if strcmp(pmkt(i,1),'Conakry')==1; id(i,1) = 435; end;
if strcmp(pmkt(i,1),'Kankan')==1; id(i,1) = 436; end;
if strcmp(pmkt(i,1),'Labe')==1; id(i,1) = 438; end;
if strcmp(pmkt(i,1),'Nzerekore')==1; id(i,1) = 439; end;
if strcmp(pmkt(i,1),'Bissau')==1; id(i,1) = 440; end;
if strcmp(pmkt(i,1),'Gbarnga')==1; id(i,1) = 441; end;
if strcmp(pmkt(i,1),'Monrovia')==1; id(i,1) = 442; end;
if strcmp(pmkt(i,1),'Bamako')==1; id(i,1) = 443; end;
if strcmp(pmkt(i,1),'Gao')==1; id(i,1) = 444; end;
if strcmp(pmkt(i,1),'Kayes')==1; id(i,1) = 445; end;
if strcmp(pmkt(i,1),'Mopti')==1; id(i,1) = 446; end;
if strcmp(pmkt(i,1),'Segou')==1; id(i,1) = 447; end;
if strcmp(pmkt(i,1),'Sikasso')==1; id(i,1) = 448; end;
if strcmp(pmkt(i,1),'AdelBagrou')==1; id(i,1) = 449; end;
if strcmp(pmkt(i,1),'Nouakchott')==1; id(i,1) = 450; end;
if strcmp(pmkt(i,1),'Tintane')==1; id(i,1) = 451; end;
if strcmp(pmkt(i,1),'Agadez')==1; id(i,1) = 452; end;
if strcmp(pmkt(i,1),'Arlit')==1; id(i,1) = 453; end;
if strcmp(pmkt(i,1),'Diffa')==1; id(i,1) = 454; end;
if strcmp(pmkt(i,1),'Maradi')==1; id(i,1) = 455; end;
if strcmp(pmkt(i,1),'Niamey')==1; id(i,1) = 456; end;
if strcmp(pmkt(i,1),'Tahoua')==1; id(i,1) = 457; end;
if strcmp(pmkt(i,1),'Zinder')==1; id(i,1) = 458; end;
if strcmp(pmkt(i,1),'Abuja')==1; id(i,1) = 460; end;
if strcmp(pmkt(i,1),'Akure')==1; id(i,1) = 461; end;
if strcmp(pmkt(i,1),'BeninCity')==1; id(i,1) = 462; end;
if strcmp(pmkt(i,1),'Calabar')==1; id(i,1) = 463; end;
if strcmp(pmkt(i,1),'Enugu')==1; id(i,1) = 464; end;
if strcmp(pmkt(i,1),'Gombe')==1; id(i,1) = 465; end;
if strcmp(pmkt(i,1),'Ibadan')==1; id(i,1) = 466; end;
if strcmp(pmkt(i,1),'Ilorin')==1; id(i,1) = 467; end;
if strcmp(pmkt(i,1),'Jos')==1; id(i,1) = 468; end;
if strcmp(pmkt(i,1),'Kaduna')==1; id(i,1) = 469; end;
if strcmp(pmkt(i,1),'Kano')==1; id(i,1) = 470; end;
if strcmp(pmkt(i,1),'Katsina')==1; id(i,1) = 471; end;
if strcmp(pmkt(i,1),'Lagos')==1; id(i,1) = 472; end;
if strcmp(pmkt(i,1),'Lokoja')==1; id(i,1) = 473; end;
if strcmp(pmkt(i,1),'Maiduguri')==1; id(i,1) = 474; end;
if strcmp(pmkt(i,1),'Makurdi')==1; id(i,1) = 475; end;
if strcmp(pmkt(i,1),'PortHarcourt')==1; id(i,1) = 476; end;
if strcmp(pmkt(i,1),'Sokoto')==1; id(i,1) = 477; end;
if strcmp(pmkt(i,1),'Yola')==1; id(i,1) = 478; end;
if strcmp(pmkt(i,1),'Dakar')==1; id(i,1) = 480; end;
if strcmp(pmkt(i,1),'Kaolack')==1; id(i,1) = 481; end;
if strcmp(pmkt(i,1),'SaintLouis')==1; id(i,1) = 482; end;
if strcmp(pmkt(i,1),'Tambacounda')==1; id(i,1) = 483; end;
if strcmp(pmkt(i,1),'Touba')==1; id(i,1) = 484; end;
if strcmp(pmkt(i,1),'Ziguinchor')==1; id(i,1) = 485; end;
if strcmp(pmkt(i,1),'Bo')==1; id(i,1) = 490; end;
if strcmp(pmkt(i,1),'Freetown')==1; id(i,1) = 491; end;
if strcmp(pmkt(i,1),'Kabala')==1; id(i,1) = 492; end;
if strcmp(pmkt(i,1),'Kara')==1; id(i,1) = 493; end;
if strcmp(pmkt(i,1),'Lome')==1; id(i,1) = 494; end;
if strcmp(pcrp(i,1),'Maize')==1; id(i,2) = 1; end;
if strcmp(pcrp(i,1),'Millet')==1; id(i,2) = 2; end;
if strcmp(pcrp(i,1),'Rice')==1; id(i,2) = 3; end;
if strcmp(pcrp(i,1),'Sorghum')==1; id(i,2) = 4; end;
if strcmp(pcrp(i,1),'Teff')==1; id(i,2) = 5; end;
if strcmp(pcrp(i,1),'Wheat')==1; id(i,2) = 6; end;
end;

%harmo is a 12-column vector with each row 1 cycle's worth of price data
harmo = zeros(10*sz(1,1),12);
for i=1:sz(1,1);
    if id(i,1)<200;
        for j=1:10;
            harmo(10*i-10+j,1:12) = pdat2(i,((j-1)*12+1):((j-1)*12+12));
        end;
    end;
    if id(i,1)>199 && id(i,1)<300;
        for j=1:9;
            harmo(10*i-10+j,1:12) = pdat2(i,((j-1)*12+3):((j-1)*12+14));
        end;
        harmo(10*i,1:10) = pdat2(i,111:120);
    end;
    if id(i,1)>299;
        for j=1:9;
            harmo(10*i-10+j,1:12) = pdat2(i,((j-1)*12+6):((j-1)*12+17));
        end;
        harmo(10*i,1:7) = pdat2(i,114:120);
    end;
end;

unq = unique(id(1:sz(1,1),1));
sz2 = size(unq);
%cropsum is a 2 column vector with market id and number of crops
cropsum = ones(sz2(1,1),2);
j=1;%index of markets
cropsum(1,1) = id(1,1);
for i=2:sz(1,1);
    if id(i,1)==id(i-1,1);
        cropsum(j,2) = cropsum(j,2)+1;
    else j=j+1;
        cropsum(j,1) = id(i,1);
    end;
end;

tee = zeros(10*sz(1,1),1);
%tee tells how many periods of storage for each row of harmo
for i=1:10*sz(1,1);
    t=0;
    if harmo(i,1)>0;
        t=1;
        if harmo(i,2)>0;
            t=2;
            if harmo(i,3)>0;
                t=3;
                if harmo(i,4)>0;
                    t=4;
                    if harmo(i,5)>0;
                        t=5;
                        if harmo(i,6)>0;
                            t=6;
                            if harmo(i,7)>0;
                                t=7;
                                if harmo(i,8)>0;
                                    t=8;
                                    if harmo(i,9)>0;
                                        t=9;
                                        if harmo(i,10)>0;
                                            t=10;
                                            if harmo(i,11)>0;
                                                t=11;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
    tee(i,1) = t;
end;

missing = zeros(10*sz(1,1),1);
%missing tells how many storage pers don't have data for each row of harmo
for i=1:10*sz(1,1);
    missing(i,1) = sum(harmo(i,1:tee(i,1)) == 999);
end;

%get min and max for each row of harmo in harmomm
harmomm = zeros(10*sz(1,1),2);
for i=1:10*sz(1,1);
    if tee(i,1)>=3;
    if missing(i,1)<=(tee(i,1)/3);
    harmomm(i,1) = min(harmo(i,1:tee(i,1))');
    help11 = harmo(i,1:tee(i,1))';
        help22 = size(help11);
        for z=1:help22(1,1);
            if help11(z,1)==999;
                help11(z,1)=0;
            end;
        end;
    harmomm(i,2) = max(help11);
    else harmomm(i,1) = 999;
    harmomm(i,2) = 999;
    end;
    else harmomm(i,1) = 999;
    harmomm(i,2) = 999;
    end;
end;

%harmommex 6 cols: mktid, cropid, year, min, max, s months (from tee)
harmommex = zeros(10*sz(1,1),6);
for j=1:sz(1,1);
    harmommex((10*j-9):(10*j),1) = id(j,1);
    harmommex((10*j-9):(10*j),2) = id(j,2);
    harmommex((10*j-9):(10*j),3) = [2003:1:2012]';
end;
harmommex(1:10*sz(1,1),4:5) = harmomm;
for i=1:10*sz(1,1);
    harmommex(i,6)=tee(i,1);
end;

csvwrite('rknewdematlab.csv', harmommex);

