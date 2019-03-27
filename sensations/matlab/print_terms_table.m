clear all
close all

%% print a table with
% Finnish | English | Synonim used for semantic distance | Neurosynth terms

finnish_labels={
'Suru'
'Viha'
'Ilo'
'Pelko'
'Hämmästys'
'Inho'
'Ylpeys'
'Kiitollisuus'
'Kaipaus'
'Halveksunta'
'Epätoivo'
'Häpeä'
'Syyllisyys'
'Pettymys'
'Mielihyvä'
'Jännittäminen'
'Voittaminen'
'Häviäminen'
'Onnistuminen'
'Epäonnistuminen'
'Haluaminen'
'Himoitseminen'
'Odottaminen'
'Itsensä hillitseminen'
'Läheisyydenkaipuu'
'Puhuminen'
'Nauraminen'
'Rakkaus'
'Ulkopuolisuus'
'Yhteenkuuluvuus'
'Yksinäisyys'
'Torjutuksi tuleminen'
'Läheisyys (ihmissuhteessa)'
'Vihamielisyys'
'Myötätunto'
'Ahdistuneisuus'
'Paniikki'
'Stressi'
'Masennus'
'Maanisuus'
'Syöminen'
'Juominen'
'Nälkä'
'Kylläisyys'
'Jano'
'Hikoileminen'
'Virtsaaminen'
'Ulostaminen'
'Väsymys'
'Vireys'
'Uupumus'
'Hengittäminen'
'Sydämen sykkiminen'
'Humala'
'Kiihottuminen'
'Orgasmi'
'Vapina'
'Krapula'
'Närästys'
'Tukehtuminen'
'Rentoutuminen'
'Nukkuminen'
'Ajatteleminen'
'Muistaminen'
'Tarkkaavaisuus'
'Unohtaminen'
'Lukeminen'
'Kuvitteleminen'
'Uneksiminen'
'Päätteleminen'
'Järkeileminen'
'Arvioiminen'
'Tietoisuus'
'Mieleenpainaminen'
'Tunnistaminen'
'Mieleen palauttaminen'
'Flunssa'
'Kuume'
'Vatsatauti'
'Nuha'
'Päänsärky'
'Pahoinvointi '
'Hammassärky'
'Yskiminen'
'Aivastaminen'
'Särky'
'Häikäistyminen'
'Näkeminen'
'Kuuleminen'
'Kosketuksen tunteminen'
'Haistaminen'
'Maistaminen'
'Kutina'
'Puutuminen'
'Kipu'
'Kuumuus'
'Kylmyys'
'Huimaus'
'Liikkuminen'
'Kiihtyvyys'
};

% english
load_labels; 
english_labels=labels;

% semantic terms
load_semantic_labels; % variable semantic_labels

% neurosynth terms
nsdata_manual; % variable data
for d=1:length(data)
    % check if the file exists;
    list=data{d};
    this_terms='';
   if(length(list)==0) continue; end
   
   
   for f=1:length(list)
       if(exist(['data/ns/ns_images/' list{f}],'file') ==2)
           temp=strrep(list{f},'_pFgA_z_FDR_0.01.nii','');
           temp=strrep(temp,'_',' ');
            this_terms=[this_terms  temp ', '];
       else
           disp(['FILE MISSING ns_images/' list{f}])
           continue
       end
      
   end
   this_terms(end-1:end)=[]; % get rid of last terms
   ns_labels{d,1}=this_terms;
   
end


%% and now print the table
disp(['Finnish term|English translation|Term used with semantic distance tool|NeuroSynth terms'])
for d=1:100
   disp([finnish_labels{d} '|' english_labels{d} '|' semantic_labels{d} '|' ns_labels{d}])
end
