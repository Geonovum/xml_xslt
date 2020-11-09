<?xml version="1.0" encoding="UTF-8"?>
<sch:schema queryBinding="xslt2" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <sch:ns prefix="data" uri="https://standaarden.overheid.nl/stop/imop/data/"/>
  <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>

  <sch:p>Versie 1.0.4</sch:p>
  <sch:p>Schematron voor aanvullende validatie van de regels voor AKNs en JOINs</sch:p>

  <sch:pattern id="sch_data_001" see="data:FRBRWork data:FRBRExpression data:instrumentVersie data:doel">
    <sch:title>AKN- of JOIN-identificatie mag geen punt bevatten</sch:title>
    <sch:rule context="data:FRBRWork | data:FRBRExpression | data:instrumentVersie | data:doel">
      <sch:p>Een AKN- of JOIN-identificatie mag geen punt bevatten</sch:p>
      <sch:report id="STOP1000" role="error" test="contains(., '.')">
        {"code": "STOP1000", "ID": "<sch:value-of select="."/>", "melding": "De identifier <sch:value-of select="."/> bevat een punt. Dit is niet toegestaan. Verwijder de punt.", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="sch_data_002" see="data:ExpressionIdentificatie data:FRBRWork
    data:FRBRExpression">
    <sch:title>ExpressionID begint met WorkID</sch:title>
    <sch:rule context="data:ExpressionIdentificatie">
      <sch:p>Het deel vóór de @ van de FRBRExpression moet gelijk aan zijn FRBRWork</sch:p>
      <sch:assert id="STOP1001" role="error" test="starts-with(data:FRBRExpression/normalize-space(), data:FRBRWork/normalize-space())">
        {"code": "STOP1001", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "Expression-ID": "<sch:value-of select="data:FRBRExpression"/>", "melding": "Het gedeelte van de FRBRExpression <sch:value-of select="data:FRBRExpression"/> vóór de 'taalcode/@' is niet gelijk aan de FRBRWork-identificatie <sch:value-of select="data:FRBRWork"/>.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="sch_data_005" see="data:ExpressionIdentificatie">
    <sch:title>AKN/JOIN validaties Expression/Work in ExpressionIdentificatie</sch:title>
    <sch:rule context="data:ExpressionIdentificatie">
      <sch:let name="soortWork" value="./data:soortWork/string()"/>
      <sch:let name="Expression" value="./data:FRBRExpression/string()"/>
      <sch:let name="Work" value="./data:FRBRWork/string()"/>
      <sch:let name="Expression_reeks" value="tokenize($Expression, '/')"/>
      <sch:let name="Expression_objecttype" value="$Expression_reeks[3]"/>
      <sch:let name="Expression_land" value="$Expression_reeks[3]"/>
      <sch:let name="Expression_collectie" value="$Expression_reeks[4]"/>
      <sch:let name="Expression_documenttype" value="$Expression_reeks[4]"/>
      <sch:let name="Expression_overheid" value="$Expression_reeks[5]"/>
      <sch:let name="Expression_datum_work" value="$Expression_reeks[6]"/>
      <sch:let name="Expression_restdeel" value="$Expression_reeks[8]"/>
      <sch:let name="Expression_restdeel_reeks" value="tokenize($Expression_restdeel, '@')"/>
      <sch:let name="Expression_taal" value="$Expression_restdeel_reeks[1]"/>
      <sch:let name="Expression_restdeel_deel2" value="$Expression_restdeel_reeks[2]"/>
      <sch:let name="Expression_restdeel_deel2_reeks"
        value="tokenize($Expression_restdeel_deel2, ';')"/>
      <sch:let name="Expression_datum_expr" value="$Expression_restdeel_deel2_reeks[1]"/>
      
      <sch:let name="Work_reeks" value="tokenize($Work, '/')"/>
      <sch:let name="Work_objecttype" value="$Work_reeks[3]"/>
      <sch:let name="Work_land" value="$Work_reeks[3]"/>
      <sch:let name="Work_collectie" value="$Work_reeks[4]"/>
      <sch:let name="Work_documenttype" value="$Work_reeks[4]"/>
      <sch:let name="Work_overheid" value="$Work_reeks[5]"/>
      <sch:let name="Work_datum_work" value="$Work_reeks[6]"/>
      
      <sch:let name="is_join" value="$soortWork = '/join/id/stop/work_010'"/>
      <sch:let name="is_akn"
        value="$soortWork = '/join/id/stop/work_003' or $soortWork = '/join/id/stop/work_015' or $soortWork = '/join/id/stop/work_019' or $soortWork = '/join/id/stop/work_006' or $soortWork = '/join/id/stop/work_021'"/>
      
      <sch:let name="is_besluit" value="$soortWork = '/join/id/stop/work_003'"/>
      <sch:let name="is_regeling"
        value="$soortWork = '/join/id/stop/work_019' or $soortWork = '/join/id/stop/work_006' or $soortWork = '/join/id/stop/work_021'"/>
      <sch:let name="is_publicatie" value="$soortWork = '/join/id/stop/work_015'"/>
      <sch:let name="is_informatieobject" value="$soortWork = '/join/id/stop/work_010'"/>
      <sch:let name="is_geconsolideerderegeling" value="$soortWork = '/join/id/stop/work_006'"/>
	   
      <sch:let name="landexpressie" value="'^(nl|aw|cw|sx)$'"/>
      <sch:let name="overheidexpressie" value="'^(mnre\d{4}|mn\d{3}|gm\d{4}|ws\d{4}|pv\d{2})$'"/>
      <sch:let name="bladcode" value="'^(bgr|gmb|prb|stb|stcrt|trb|wsb)$'"/>
      <sch:let name="taalexpressie" value="'^(nld|eng|fry|pap|mul|und)$'"/>
      <sch:let name="collectieexpressie" value="'^(regdata|infodata|pubdata)$'"/>
	  
      <sch:p>AKN-identificatie (work) MOET als tweede deel een geldig land hebben</sch:p>
      <sch:report id="STOP1002" role="error" test="$is_akn and not(matches($Work_land, $landexpressie))">
	    {"code": "STOP1002", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "substring": "<sch:value-of select="$Work_land"/>", "melding": "Landcode <sch:value-of select="$Work_land"/> in de AKN-identificatie <sch:value-of select="data:FRBRWork"/> is niet toegestaan. Pas landcode aan.", "ernst": "fout"},</sch:report>
      
      <sch:p>AKN-identificatie (Work) van officiele publicatie MOET als derde deel officialGazette
        hebben</sch:p>
      <sch:report id="STOP1011" role="error" test="$is_publicatie and not(matches($Work_documenttype, '^officialGazette$'))">
	    {"code": "STOP1011", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "substring": "<sch:value-of select="$Work_documenttype"/>", "melding": "Derde veld <sch:value-of select="$Work_documenttype"/> in de AKN-identificatie <sch:value-of select="data:FRBRWork"/> is niet toegestaan bij officiele publicatie. Pas dit veld aan.", "ernst": "fout"},</sch:report>
      
      <sch:p>AKN-identificatie (Work) van besluit MOET als derde deel bill hebben</sch:p>
      <sch:report id="STOP1013" role="error" test="$is_besluit and not(matches($Work_documenttype, '^bill$'))">
	    {"code": "STOP1013", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "substring": "<sch:value-of select="$Work_documenttype"/>", "melding": "Derde veld <sch:value-of select="$Work_documenttype"/> in de AKN-identificatie <sch:value-of select="data:FRBRWork"/> is niet toegestaan bij besluit. Pas dit veld aan.", "ernst": "fout"},</sch:report>
      
      <sch:p>AKN-identificatie (work) van (evt gecons) regeling MOET als derde deel act
        hebben</sch:p>
      <sch:report id="STOP1012" role="error" test="$is_regeling and not(matches($Work_documenttype, '^act$'))">
	    {"code": "STOP1012", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "substring": "<sch:value-of select="$Work_documenttype"/>", "melding": "Derde veld <sch:value-of select="$Work_documenttype"/> in de AKN-identificatie <sch:value-of select="data:FRBRWork"/> is niet toegestaan bij regeling. Pas dit veld aan.", "ernst": "fout"},</sch:report>
      
      <sch:p>JOIN-identificatie (work) MOET als tweede deel 'id' hebben</sch:p>
      <sch:report id="STOP1003" role="error" test="$is_join and not(matches($Work_objecttype, '^id$'))">
	  	{"code": "STOP1003", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "melding": "Tweede deel JOIN-identificatie <sch:value-of select="data:FRBRWork"/> moet gelijk zijn aan 'id'. Pas dit aan.", "ernst": "fout"},</sch:report>
      
      <sch:p>JOIN-identificatie (werk) MOET als derde deel regdata,pubdata, infodata hebben</sch:p>
      <sch:report id="STOP1004" role="error" test="$is_join and not(matches($Work_collectie, $collectieexpressie))">
	  	{"code": "STOP1004", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "melding": "Derde deel JOIN-identificatie <sch:value-of select="data:FRBRWork"/> moet gelijk zijn aan regdata, pubdata, of infodata. Pas dit aan.", "ernst": "fout"},</sch:report>
      
      <sch:p>AKN of JOIN identificatie MOET als vijfde deel jaartal of geldigde datum hebben</sch:p>
      <sch:report id="STOP1006" role="error" test="($is_join or $is_akn) and not(($Work_datum_work castable as xs:date) or ($Work_datum_work castable as xs:gYear))">
		  {"code": "STOP1006", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "melding": "Vijfde deel AKN- of JOIN-identificatie <sch:value-of select="data:FRBRWork"/> moet gelijk zijn aan jaartal of geldige datum. Pas dit aan.", "ernst": "fout"},</sch:report>
      
      <sch:p>JOIN-identificatie (expressie) MOET als eerste deel na de '@' een jaartal of een
        geldige datum hebben</sch:p>
      <sch:report id="STOP1007" role="error" test="$is_join and not(($Expression_datum_expr castable as xs:date) or ($Expression_datum_expr castable as xs:gYear))">
		  {"code": "STOP1007", "Expression-ID": "<sch:value-of select="data:FRBRExpression"/>", "melding": "Voor een JOIN-identificatie (<sch:value-of select="data:FRBRExpression"/>) moet het eerste deel na de '@' een jaartal of een geldige datum zijn. Pas dit aan.", "ernst": "fout"},</sch:report>
      
      <sch:p>JOIN-identificatie (expressie) MOET als eerste deel na de '@' een jaartal of een
        geldige datum hebben groter/gelijk aan jaartal in werk</sch:p>
      <sch:report id="STOP1008" role="error" test="$is_join and not($Expression_datum_expr >= $Expression_datum_work)"> 
		  {"code": "STOP1008", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "Expression-ID": "<sch:value-of select="data:FRBRExpression"/>", "melding": "JOIN-identificatie (<sch:value-of select="data:FRBRExpression"/>) MOET als eerste deel na de '@' een jaartal of een geldige datum hebben groter/gelijk aan jaartal in werk (<sch:value-of select="data:FRBRWork"/>). Pas dit aan.", "ernst": "fout"},</sch:report>
      
      <sch:p>AKN- of JOIN-identificatie (expressie) MOET als deel voorafgaand aan de '@' een geldige
        taal hebben</sch:p>
      <sch:report id="STOP1009" role="error" test="($is_join or $is_akn) and not(matches($Expression_taal, $taalexpressie))">
		  {"code": "STOP1009", "Expression-ID": "<sch:value-of select="data:FRBRExpression"/>", "substring": "<sch:value-of select="$Expression_taal"/>", "melding": "Voor een AKN- of JOIN-identificatie (<sch:value-of select="data:FRBRExpression"/>) moet deel voorafgaand aan de '@' (<sch:value-of select="$Expression_taal"/>) een geldige taal zijn ('nld','eng','fry','pap','mul','und'). Pas dit aan.", "ernst": "fout"},</sch:report>
      
      <sch:p>Vierde deel AKN werken niet offpub en niet geconsolideerde regeling MOET brp-code zijn</sch:p>
      <sch:report id="STOP1010" role="error" test="($is_akn or $is_join) and not($is_publicatie) and not ($is_geconsolideerderegeling) and not(matches($Work_overheid, $overheidexpressie))"> 
		  {"code": "STOP1010", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "substring": "<sch:value-of select="$Work_overheid"/>", "melding": "Vierde deel van AKN/JOIN van werk (<sch:value-of select="data:FRBRWork"/>) moet gelijk zijn aan een brp-code. Pas (<sch:value-of select="$Work_overheid"/>) aan.", "ernst": "fout"},</sch:report>
      
      <sch:p>Vierde deel AKN van offpub werken MOET bladcode zijn</sch:p>
      <sch:report id="STOP1017" role="error" test="$is_publicatie and not (matches($Work_overheid, $bladcode))"> 
		  {"code": "STOP1017", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "substring": "<sch:value-of select="$Work_overheid"/>", "melding": "Vierde veld <sch:value-of select="$Work_overheid"/> in de AKN-identificatie <sch:value-of select="data:FRBRWork"/> is niet toegestaan bij officiele publicatie. Pas dit veld aan.", "ernst": "fout"},</sch:report>
      
    </sch:rule>
  </sch:pattern>
 
  <sch:pattern id="sch_data_003" see="data:FRBRWork data:FRBRExpression data:instrumentVersie
    data:doel">
    <sch:title>AKN en JOIN identificaties starten met /akn/ of /join/</sch:title>
    <sch:rule context="data:FRBRWork | data:FRBRExpression | data:instrumentVersie | data:doel">
      <sch:p>Een AKN of JOIN identificatie MOET starten met /akn/ of /join/</sch:p>
      <sch:assert id="STOP1014" role="error" test="starts-with(./normalize-space(), '/akn/') or starts-with(./normalize-space(), '/join/')">
        {"code": "STOP1014", "ID": "<sch:value-of select="."/>", "melding": "De waarde <sch:value-of select="."/> begint niet met /akn/ of /join/. Pas de waarde aan.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  
</sch:schema>

