<?xml version="1.0" encoding="UTF-8"?>
<sch:schema queryBinding="xslt2" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:se="http://www.opengis.net/se"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <sch:ns prefix="geo" uri="https://standaarden.overheid.nl/stop/imop/geo/" />
  <sch:ns prefix="se" uri="http://www.opengis.net/se" />
  <sch:ns prefix="ogc" uri="http://www.opengis.net/ogc" />
  <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform" />
  <sch:ns prefix="basisgeo" uri="http://www.geostandaarden.nl/basisgeometrie/1.0" />
  <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2" />

  <sch:p>Versie @@@VERSIE@@@</sch:p>
  <sch:p>Schematron voor aanvullende validatie voor het STOP-deel van de Symbol Encoding (se)
    standaard.</sch:p>

  <sch:pattern id="sch_se_001" see="se:FeatureTypeStyle">
    <sch:title>Symbolisatie rules</sch:title>
    <sch:rule context="se:FeatureTypeStyle">
      <sch:p>De FeatureTypeStyle MAG GEEN se:Name bevatten.</sch:p>
      <sch:assert id="STOP3100" role="warning" test="not(se:Name)">
        {"code": "STOP3100", "ID": "<sch:value-of select="./se:Name" />", "melding": "De FeatureTypeStyle bevat een Name <sch:value-of select="./se:Name" />, deze informatie wordt genegeerd.", "ernst": "waarschuwing"},</sch:assert>

      <sch:p>De FeatureTypeStyle MAG GEEN se:Description bevatten.</sch:p>
      <sch:assert id="STOP3101" role="warning" test="not(se:Description)">
        {"code": "STOP3101", "ID": "<sch:value-of select="./se:Description/normalize-space()" />", "melding": "De FeatureTypeStyle bevat een Description \"<sch:value-of select="./se:Description/normalize-space()" />\", deze informatie wordt genegeerd.", "ernst": "waarschuwing"},</sch:assert>
      
      <sch:p>FeatureTypeStyle version MOET zijn "1.1.0".</sch:p>
      <sch:assert id="STOP3105" role="warning" test="./@version='1.1.0'">
        {"code": "STOP3105", "ID": "<sch:value-of select="./@version" />", "melding": "De FeatureTypeStyle versie is <sch:value-of select="./@version" />, dit moet 1.1.0 zijn. Wijzig het SE versie nummer.", "ernst": "waarschuwing"},</sch:assert>
    </sch:rule>

    <sch:rule context="se:FeatureTypeName">
      <sch:p>De FeatureTypeStyle:FeatureTypeName MOET geo:Locatie zijn.</sch:p>
      <sch:assert id="STOP3102" role="error" test="string(.) = 'geo:Locatie'">
        {"code": "STOP3102", "ID": "<sch:value-of select="." />", "melding": "De FeatureTypeStyle:FeatureTypeName is <sch:value-of select="." />, dit moet geo:Locatie zijn. Wijzig de FeatureTypeName in geo:Locatie.", "ernst": "fout"},</sch:assert>
    </sch:rule>

    <sch:rule context="se:SemanticTypeIdentifier">
      <sch:p>FeatureTypeStyle:SemanticTypeIdentifier MOET zijn geo:geometrie, geo:groepID,
        geo:kwalitatieveNormwaarde of geo:kwantitatieveNormwaarde.</sch:p>
      <sch:assert id="STOP3103" role="error" test="(.= 'geo:geometrie') or (.= 'geo:kwalitatieveNormwaarde') or (.= 'geo:groepID') or (. = 'geo:kwantitatieveNormwaarde')">
        {"code": "STOP3103", "ID": "<sch:value-of select="." />", "melding": "De FeatureTypeStyle:SemanticTypeIdentifier is <sch:value-of select="." />, dit moet geo:geometrie, geo:groepID, geo:kwalitatieveNormwaarde of geo:kwantitatieveNormwaarde zijn. Wijzig de SemanticTypeIdentifier.", "ernst": "fout"},</sch:assert>
    </sch:rule>

    <sch:rule context="ogc:Filter">
      <sch:p>Als Rule een Filter bevat dan MOET de SemanticTypeIdentifier geo:groepID,
        geo:kwalitatieveNormwaarde of geo:kwantitatieveNormwaarde zijn.</sch:p>
      <sch:let name="ID" value="preceding::se:SemanticTypeIdentifier"/>
      <sch:assert id="STOP3114" role="error" test="($ID = 'geo:kwalitatieveNormwaarde') or ($ID = 'geo:groepID') or ($ID = 'geo:kwantitatieveNormwaarde')">
        {"code": "STOP3114", "ID": "<sch:value-of select="preceding::se:SemanticTypeIdentifier"/>", "melding": "Rule heeft een Filter terwijl de SemanticTypeIdentifier <sch:value-of select="preceding::se:SemanticTypeIdentifier"/> is. Verwijder het Filter, of wijzig de SemanticTypeIdentifier.", "ernst": "fout"},</sch:assert>           
    </sch:rule>

    <sch:rule context="ogc:PropertyName">
      <sch:p>PropertyName MOET overeenkomen met de SemanticTypeIdentifier (zonder geo:
        voorvoegsel).</sch:p>
      <sch:assert id="STOP3115" role="error" test=".= substring-after(preceding::se:SemanticTypeIdentifier, ':')">
        {"code": "STOP3115", "ID": "<sch:value-of select="." />", "ID2": "<sch:value-of select="preceding::se:SemanticTypeIdentifier"/>", "melding": "PropertyName is <sch:value-of select="." />, dit moet overeenkomen met de SemanticTypeIdentifier <sch:value-of select="preceding::se:SemanticTypeIdentifier"/> (zonder geo: voorvoegsel). Corrigeer de PropertyName van het filter of pas de SemanticTypeIdentifier aan.", "ernst": "fout"},</sch:assert>           
    </sch:rule>

    <sch:rule
      context="ogc:PropertyIsBetween | ogc:PropertyIsNotEqualTo | ogc:PropertyIsLessThan | ogc:PropertyIsGreaterThan | ogc:PropertyIsLessThanOrEqualTo | ogc:PropertyIsGreaterThanOrEqualTo">
      <sch:p>Als Rule:Filter:PropertyIsBetween, PropertyIsNotEqualTo, PropertyIsLessThan,
        PropertyIsGreaterThan, PropertyIsLessThanOrEqualTo of PropertyIsGreaterThanOrEqualTo is, dan
        MOET de SemanticTypeIdentifier gelijk zijn aan geo:kwantitatieveNormwaarde.</sch:p>
      <sch:assert id="STOP3118" role="error" test="(preceding::se:SemanticTypeIdentifier = 'geo:kwantitatieveNormwaarde') ">
        {"code": "STOP3118", "ID": "<sch:value-of select="preceding::se:SemanticTypeIdentifier"/>", "melding": "De SemanticTypeIdentifier is <sch:value-of select="preceding::se:SemanticTypeIdentifier"/>. De operator in Rule:Filter is alleen toegestaan bij SemanticTypeIdentifier geo:kwantitatieveNormwaarde. Corrigeer de operator of pas de SemanticTypeIdentifier aan.", "ernst": "fout"},</sch:assert>           
    </sch:rule>
      
    <sch:rule context="ogc:And"> 
      <sch:p>Rule:Filter:And MOET de operanden PropertyIsLessThan en PropertyIsGreaterThanOrEqualTo
        bevatten.</sch:p>
      <sch:assert id="STOP3120" role="error" test="./ogc:PropertyIsGreaterThanOrEqualTo and ./ogc:PropertyIsLessThan ">
        {"code": "STOP3120", "ID": "<sch:value-of select="preceding::se:Name"/>", "melding": "In Rule met Rule:Name <sch:value-of select="preceding::se:Name"/> is de operator in Rule:Filter AND, maar de operanden zijn niet PropertyIsLessThan en PropertyIsGreaterThanOrEqualTo. Corrigeer de And expressie in het filter.", "ernst": "fout"},</sch:assert>           
    </sch:rule>
    
    <sch:rule context="se:Rule/se:Description/se:Title"> 
      <sch:p>De Description:Title MAG NIET leeg zijn (dit is de legenda regel).</sch:p>
      <sch:assert id="STOP3126" role="error" test="./normalize-space() != ''">
        {"code": "STOP3126", "ID": "<sch:value-of select="preceding::se:Name"/>", "melding": "In Rule met Rule:Name <sch:value-of select="preceding::se:Name"/> is de Description:Title leeg, deze moet een tekst bevatten die in de legenda getoond kan worden. Voeg de legenda tekst toe aan de Description:Title.", "ernst": "fout"},</sch:assert>           
    </sch:rule>
  
    <sch:rule context="se:PointSymbolizer"> 
      <sch:p>De PointSymbolizer:Graphic:Mark:Fill MAG GEEN se:GraphicFill bevatten</sch:p>
      <sch:assert id="STOP3135" role="error" test="not(./se:Graphic/se:Mark/se:Fill/se:GraphicFill)">
        {"code": "STOP3135", "ID": "<sch:value-of select="./se:Name"/>", "melding": "De PointSymbolizer van Rule:Name <sch:value-of select="./se:Name"/> heeft een Mark:Fill:GraphicFill, dit is niet toegestaan. Gebruik SvgParameter.", "ernst": "fout"},</sch:assert>
           
      <sch:p>Een Fill in de PointSymbolizer MOET tenminste één se:SvgParameter bevatten.</sch:p>
      <sch:assert id="STOP3138" role="error" test="./se:Graphic/se:Mark/se:Fill/se:SvgParameter">
        {"code": "STOP3138", "ID": "<sch:value-of select="./se:Name"/>", "melding": "De PointSymbolizer van Rule:Name <sch:value-of select="./se:Name"/> heeft niet de vorm se:Graphic/se:Mark/se:Fill/se:GraphicFill/se:SvgParameter, dit is verplicht. Wijzig deze symbolizer.", "ernst": "fout"},</sch:assert>   
      
    </sch:rule>

    <sch:rule context="se:SvgParameter[@name='stroke']">
      <sch:p>SvgParameter met "name" attribute "stroke" MOET aan de reguliere expressie
        ^#[0-9a-f]{6}$ voldoen. (string van 7 karakters, met als eerste karakters een # en de
        volgende zes karakters een hexadecimale waarde.)</sch:p>
      <sch:assert id="STOP3140" role="error" test="matches(./string(),'^#[0-9a-f]{6}$')">
       {"code": "STOP3140", "ID": "<sch:value-of select="."/>", "melding": "SvgParameter name=\"stroke\" waarde:<sch:value-of select="."/>, is ongeldig. Vul deze met een valide hexadecimale waarde.", "ernst": "fout"},</sch:assert>
    </sch:rule>
    
    <sch:rule context="se:SvgParameter[@name='fill']">
      <sch:p>SvgParameter met "name" attribute "fill" MOET aan de reguliere expressie ^#[0-9a-f]{6}$
        voldoen. (string van 7 karakters, met als eerste karakters een # en de volgende zes
        karakters een hexadecimale waarde.)</sch:p>
      <sch:assert id="STOP3147" role="error" test="matches(./string(),'^#[0-9a-f]{6}$')">
       {"code": "STOP3147", "ID": "<sch:value-of select="."/>", "melding": "SvgParameter name=\"fill\" waarde: <sch:value-of select="."/>, is ongeldig. Vul deze met een valide hexadecimale waarde.", "ernst": "fout"},</sch:assert>
    </sch:rule>
    
    <sch:rule context="se:SvgParameter[@name='stroke-width']">
      <sch:p>SvgParameter met "name" attribute "stroke-width" MOET aan de reguliere expressie
        ^[0-9]+(.[0-9])?[0-9]?$ voldoen. (positief getal met 0, 1 of 2 decimalen)</sch:p>
      <sch:assert id="STOP3141" role="error" test="matches(./string(),'^[0-9]+(.[0-9])?[0-9]?$')">
       {"code": "STOP3141", "ID": "<sch:value-of select="."/>", "melding": "SvgParameter name=\"stroke-width\" waarde: <sch:value-of select="."/>, is ongeldig. Vul deze met een positief getal met 0,1 of 2 decimalen.", "ernst": "fout"},</sch:assert>
    </sch:rule>
    
    <sch:rule context="se:SvgParameter[@name='stroke-dasharray']">
      <sch:p>SvgParameter met "name" attribute "stroke-width" MOET aan de reguliere expressie ^([0-9]+ ?)*$ voldoen. (string met één of meer positief gehele getal gescheiden door een spatie)</sch:p>
      <sch:assert id="STOP3142" role="error" test="matches(./string(),'^([0-9]+ ?)*$')">       {"code": "STOP3142", "ID": "<sch:value-of select="."/>", "melding": "SvgParameter name=\"stroke-dasharray\" waarde: <sch:value-of select="."/>, is ongeldig. Vul deze met setjes van 2 positief gehele getallen gescheiden door spaties.", "ernst": "fout"},</sch:assert>
    </sch:rule>
    
    <sch:rule context="se:SvgParameter[@name='stroke-linecap']">
      <sch:p>SvgParameter met "name" attribute "stroke-linecap" MOET "butt" bevatten.</sch:p>
      <sch:assert id="STOP3143" role="error" test="./string()='butt'">
       {"code": "STOP3143", "ID": "<sch:value-of select="."/>", "melding": "SvgParameter name=\"stroke-linecap\" waarde: <sch:value-of select="."/>, is ongeldig. Wijzig deze in \"butt\".", "ernst": "fout"},</sch:assert>
    </sch:rule>
    
    <sch:rule context="se:SvgParameter[@name='stroke-opacity']">
      <sch:p>SvgParameter met met name attribute "stroke-opacity" MOET aan de reguliere expressie 
        ^0((.[0-9])?[0-9]?)|1((.0)?0?)$ voldoen. (string met een positief decimaal getal tussen 0 en
        1 (beide inclusief) met 0,1 of 2 decimalen)</sch:p>
      <sch:assert id="STOP3144" role="error" test="matches(./string(),'^0((.[0-9])?[0-9]?)|1((.0)?0?)$')">
       {"code": "STOP3144", "ID": "<sch:value-of select="."/>", "melding": "SvgParameter name=\"stroke-opacity\" waarde: <sch:value-of select="."/>, is ongeldig. Wijzig deze in een decimaal positief getal tussen 0 en 1 (beide inclusief) met 0,1 of 2 decimalen.", "ernst": "fout"},</sch:assert>
    </sch:rule>

    <sch:rule context="se:SvgParameter[@name='fill-opacity']">
      <sch:p>SvgParameter met met name attribute "fill-opacity" MOET aan de reguliere expressie 
        ^0((.[0-9])?[0-9]?)|1((.0)?0?)$ voldoen. (string met een positief decimaal getal tussen 0 en
        1 (beide inclusief) met 0,1 of 2 decimalen)</sch:p>
      <sch:assert id="STOP3148" role="error" test="matches(./string(),'^0((.[0-9])?[0-9]?)|1((.0)?0?)$')">
       {"code": "STOP3148", "ID": "<sch:value-of select="."/>", "melding": "SvgParameter name=\"fill-opacity\" waarde: <sch:value-of select="."/>, is ongeldig. Wijzig deze in een decimaal positief getal tussen 0 en 1 (beide inclusief) met 0,1 of 2 decimalen.", "ernst": "fout"},</sch:assert>
    </sch:rule>

    <sch:rule context="se:SvgParameter[@name='stroke-linejoin']">
      <sch:p>SvgParameter met "name" attribute "stroke-linejoin" MOET "round" bevatten.</sch:p>
      <sch:assert id="STOP3145" role="error" test="./string()='round'">
       {"code": "STOP3145", "ID": "<sch:value-of select="."/>", "melding": "SvgParameter name=\"stroke-linejoin\" waarde: <sch:value-of select="."/>, is ongeldig. Wijzig deze in \"round\".", "ernst": "fout"},</sch:assert>
    </sch:rule>

    <!-- als 3139 voor 3140 staat, werkt het niet -->
    <sch:rule context="se:Stroke/se:SvgParameter"> 
      <sch:p>Het "name" attribute van een SvgParameter MOET stroke, stroke-width, stroke-dasharray,
        stroke-linecap, stroke-opacity, of stroke-linejoin zijn.</sch:p>
      <sch:assert id="STOP3139" role="error" test="./@name='stroke' or ./@name='stroke-width' or ./@name='stroke-dasharray' or ./@name='stroke-linecap' or ./@name='stroke-opacity' or ./@name='stroke-linejoin'">
        {"code": "STOP3139", "ID": "<sch:value-of select="./@name"/>", "melding": "Een Stroke:SvgParameter met een ongeldig name attribute <sch:value-of select="./@name"/>. Maak hier een valide name attribute van.", "ernst": "fout"},</sch:assert> 
    </sch:rule>
   
    <sch:rule context="se:Fill/se:SvgParameter"> 
      <sch:p>Het "name" attribute van se:Fill/se:SvgParameter MOET fill of fill-opacity
        zijn.</sch:p>
      <sch:assert id="STOP3146" role="error" test="./@name='fill' or ./@name='fill-opacity'">
        {"code": "STOP3146", "ID": "<sch:value-of select="./@name"/>", "melding": "Een Fill:SvgParameter met een ongeldig name attribute <sch:value-of select="./@name"/>. Maak hier een valide name-attribute van.", "ernst": "fout"},</sch:assert> 
    </sch:rule>
      
    <sch:rule context="se:WellKnownName"> 
      <sch:p>De WellKnownName MOET cross (of cross_fill), square, circle, star of triangle
        zijn.</sch:p>
      <sch:assert id="STOP3157" role="error" test=".='cross' or .='cross_fill' or .='square' or .='circle' or .='star' or .='triangle'">
        {"code": "STOP3157", "ID": "<sch:value-of select="."/>", "melding": "De Mark:WellKnownName <sch:value-of select="."/> is niet toegestaan. Maak hier cross(of cross_fill), square, circle, star of triangle van.", "ernst": "fout"},</sch:assert> 
    </sch:rule>
    
    <sch:rule context="se:Size">
      <sch:p>De Size MOET aan de reguliere expressie ^[0-9]+$ voldoen. (een positief geheel
        getal)</sch:p>
      <sch:assert id="STOP3163" role="error" test="matches(./string(),'^[0-9]+$')">
       {"code": "STOP3163", "ID": "<sch:value-of select="../../se:Name"/>", "ID2": "<sch:value-of select="."/>", "melding": "De (Point/Polygon)symbolizer met se:Name <sch:value-of select="../../se:Name"/> heeft een ongeldige Graphic:Size <sch:value-of select="."/>. Wijzig deze in een geheel positief getal.", "ernst": "fout"},</sch:assert>
    </sch:rule>
    
    <sch:rule context="se:Rotation">
      <sch:p>De Graphic:Rotation MOET aan de reguliere
        expressie ^\-?[0-9]([0-9][0-9]?)?(.[0-9][0-9]?)?$ voldoen. (een positief of negatief
        decimaal getal kleiner dan 1000 met 0, 1 of 2 decimalen)</sch:p>
      <sch:assert id="STOP3164" role="error" test="matches(./string(),'^\-?[0-9]([0-9][0-9]?)?(.[0-9][0-9]?)?$')">
       {"code": "STOP3164", "ID": "<sch:value-of select="../../se:Name"/>", "ID2": "<sch:value-of select="."/>", "melding": "De (Point/Polygon)symbolizer met se:Name <sch:value-of select="../../se:Name"/> heeft een ongeldige Graphic:Rotation <sch:value-of select="."/>. Wijzig deze in een getal met maximaal 2 decimalen.", "ernst": "fout"},</sch:assert>
    </sch:rule>
     
    <sch:rule context="se:PolygonSymbolizer/se:Fill/se:GraphicFill/se:Graphic">
      <sch:p>Als de PolygonSymbolizer:Fill een GraphicFill:Graphic bevat, DAN MOET deze een
        se:ExternalGraphic bevatten.</sch:p>
      <sch:assert id="STOP3170" role="error" test="./se:ExternalGraphic and not(./se:Mark)">
        {"code": "STOP3170", "ID": "<sch:value-of select="ancestor::se:PolygonSymbolizer/se:Name"/>", "melding": "De PolygonSymbolizer:Fill:GraphicFill:Graphic met Name <sch:value-of select="ancestor::se:PolygonSymbolizer/se:Name"/> bevat geen se:ExternalGraphic of ook een se:Mark, dit is wel vereist. Voeg een se:ExternalGraphic element toe.", "ernst": "fout"},</sch:assert>
    </sch:rule>
       
    <sch:rule context="se:InlineContent[@encoding='base64']">
      <sch:p>InlineContent met attribute encoding="base64" MOET aan de reguliere expressie
        ^[A-Z0-9a-z+/ =]*$ voldoen. (hoofd- en kleine letters, cijfers, plus-teken, /-teken)</sch:p>
      <sch:assert id="STOP3173" role="error" test="matches(./normalize-space(),'^[A-Z0-9a-z+/ =]*$')">
       {"code": "STOP3173", "ID": "<sch:value-of select="ancestor::se:PolygonSymbolizer/se:Name"/>", "ID2": "<sch:value-of select="normalize-space(replace(./string(),'[A-Z0-9a-z+/ =]',''))"/>", "melding": "De PolygonSymbolizer:Fill:GraphicFill:Graphic:ExternalGraphic:InlineContent van Rule:Name <sch:value-of select="ancestor::se:PolygonSymbolizer/se:Name"/> bevat ongeldige tekens <sch:value-of select="normalize-space(replace(./string(),'[A-Z0-9a-z+/ =]',''))"/>. Wijzig dit. Een base64 encodig mag alleen bestaan uit: hoofd- en kleine letters, cijfers, spaties, plus-teken, /-teken en =-teken.", "ernst": "fout"},</sch:assert>
    </sch:rule>
    
    <sch:rule context="se:ExternalGraphic/se:Format">
      <sch:p>ExternalGraphic:Format MOET de waarde image/png hebben.</sch:p>
      <sch:assert id="STOP3174" role="error" test="./string()='image/png'">
       {"code": "STOP3174", "ID": "<sch:value-of select="ancestor::se:PolygonSymbolizer/se:Name"/>", "ID2": "<sch:value-of select="."/>", "melding": "De ExternalGraphic:Format van (Polygon)symbolizer:Name <sch:value-of select="ancestor::se:PolygonSymbolizer/se:Name"/> heeft een ongeldig Format <sch:value-of select="."/>. Wijzig deze in image/png", "ernst": "fout"},</sch:assert>
    </sch:rule>
    
</sch:pattern>
</sch:schema>
