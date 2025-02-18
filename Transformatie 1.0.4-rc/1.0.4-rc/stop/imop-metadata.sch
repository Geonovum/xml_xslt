<?xml version="1.0" encoding="UTF-8"?>
<sch:schema queryBinding="xslt2" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <sch:ns prefix="data" uri="https://standaarden.overheid.nl/stop/imop/data/" />
  <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform" />

  <sch:p>Versie @@@VERSIE@@@</sch:p>
  <sch:p>Schematron voor aanvullende validatie voor metadata</sch:p>


  <sch:pattern id="sch_data_004" see="data:InformatieObjectMetadata data:officieleTitel">
    <sch:title>OfficieleTitel InformatieObject is JOIN identifier</sch:title>
    <sch:rule context="data:InformatieObjectMetadata">
      <sch:p>De officieleTitel van een InformatieObject MOET starten met /join/id/</sch:p>
      <sch:assert id="STOP1015" role="error"
        test="starts-with(./data:officieleTitel/string(), '/join/id/')"> {"code": "STOP1015", "substring": "<sch:value-of select="./data:officieleTitel" />", "melding": "De waarde van officieleTitel <sch:value-of select="./data:officieleTitel" /> MOET starten met /join/id/. Maak er een JOIN-identifier van.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_data_006" see="data:RegelingVersieMetadata">
    <sch:title>RegelingVersieMetadata validaties</sch:title>
    <sch:rule context="data:RegelingVersieMetadata/data:versienummer">
      <sch:p>Versienummer van regeling moet voldoen onze specificaties</sch:p>
      <sch:report id="STOP1016" role="error"
        test="not(matches(./string(), '^[a-zA-Z0-9\-]{1,32}$'))"> {"code": "STOP1016", "substring": "<sch:value-of select="./string()" />", "melding": "Het versienummer van een regeling <sch:value-of select="./string()" /> MOET bestaan uit maximaal 32 cijfers, onderkast- en bovenkast-letters en -, en MAG NIET bestaan uit punt en underscore.", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_data_007" see="data:informatieobjectRefs">
    <sch:title>informatieobjectRefs uniek</sch:title>
    <sch:rule context="data:informatieobjectRefs">
      <sch:p>alle data:informatieobjectref binnen een data:informatieobjectRefs zijn uniek</sch:p>
      <sch:report id="STOP1018" role="error"
        test="count(./data:informatieobjectRef) != count(distinct-values(./data:informatieobjectRef))"
        > {"code": "STOP1018", "melding": "Alle referenties binnen informatieobjectRefs moeten uniek zijn. Pas dit aan.", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>


  <sch:pattern id="sch_data_008"
    see="data:rechtsgebieden data:overheidsdomeinen data:onderwerpen
    data:alternatieveTitels data:opvolging">
    <sch:title>data:rechtsgebieden, data:overheidsdomeinen, data:onderwerpen,
      data:alternatieveTitels, data:opvolging uniek</sch:title>
    <sch:rule context="data:rechtsgebieden">
      <sch:p>data:rechtsgebieden zijn uniek</sch:p>
      <sch:report id="STOP1019" role="error"
        test="count(./data:rechtsgebied) != count(distinct-values(./data:rechtsgebied))"> {"code": "STOP1019", "melding": "Gebruik elke waarde binnen container data:rechtsgebieden maar één keer.", "ernst": "fout"},</sch:report>
    </sch:rule>
    <sch:rule context="data:overheidsdomeinen">
      <sch:p>data:overheidsdomeinen zijn uniek</sch:p>
      <sch:report id="STOP1030" role="error"
        test="count(./data:overheidsdomein) != count(distinct-values(./data:overheidsdomein))">
        {"code": "STOP1030", "melding": "Gebruik elke waarde binnen container data:overheidsdomeinen maar één keer.", "ernst": "fout"},</sch:report>
    </sch:rule>
    <sch:rule context="data:onderwerpen">
      <sch:p>data:onderwerpen zijn uniek</sch:p>
      <sch:report id="STOP1031" role="error"
        test="count(./data:onderwerp) != count(distinct-values(./data:onderwerp))"> {"code": "STOP1031", "melding": "Gebruik elke waarde binnen container data:onderwerpen maar één keer.", "ernst": "fout"},</sch:report>
    </sch:rule>
    <sch:rule context="data:alternatieveTitels">
      <sch:p>data:alternatieveTitels zijn uniek</sch:p>
      <sch:report id="STOP1022" role="error"
        test="count(./data:alternatieveTitel) != count(distinct-values(./data:alternatieveTitel))">
        {"code": "STOP1022", "melding": "De alternatieve titels binnen alternatieveTitels MOETEN allen uniek zijn.", "ernst": "fout"},</sch:report>
    </sch:rule>
    <sch:rule context="data:opvolging">
      <sch:p>data:opvolging zijn uniek</sch:p>
      <sch:report id="STOP1023" role="error"
        test="count(./data:opvolgerVan) != count(distinct-values(./data:opvolgerVan))"> {"code": "STOP1023", "melding": "Alle opvolgerVan binnen een opvolging MOETEN uniek zijn.", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_data_009" see="data:alternatieveTitel data:citeertitel">
    <sch:title>alternatieveTitel niet gelijk aan citeertitel</sch:title>
    <sch:rule context="data:alternatieveTitel">
      <sch:p>Geen van de alternatieveTitel is gelijk aan de citeertitel</sch:p>
      <sch:report id="STOP1020" role="error"
        test="./string() = ../../data:heeftCiteertitelInformatie/data:CiteertitelInformatie/data:citeertitel/string()"
        > {"code": "STOP1020", "melding": "De citeertitel MAG NIET gelijk zijn aan een alternatieve titel.", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_data_010" see="data:opvolgerVan">
    <sch:title>data:opvolgerVan wijst naar een Work van een Regeling</sch:title>
    <sch:rule context="data:opvolgerVan">
      <sch:p>data:opvolgerVan wijst naar een Work van een Regeling</sch:p>
      <sch:assert id="STOP1024" role="error" test="matches(./string(), '^/akn/(nl|aw|cw|sx)/act')">
        {"code": "STOP1024", "substring": "<sch:value-of select="./string()" />", "melding": "In opvolgerVan (<sch:value-of select="./string()" />) MOET verwezen worden naar een Work van een Regeling.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_data_011" see="data:TekstReferentie">
    <sch:title>data:uri moet corresponderen met data:soortRef</sch:title>
    <sch:rule context="data:TekstReferentie">
      <sch:let name="is_akn" value="./data:soortRef/string() = 'AKN'" />
      <sch:let name="is_jci" value="./data:soortRef/string() = 'JCI'" />
      <sch:let name="is_url" value="./data:soortRef/string() = 'URL'" />

      <sch:let name="akn_patroon" value="'^/akn/(nl|aw|cw|sx)/act'" />
      <sch:let name="jci_patroon" value="'^jci'" />
      <sch:let name="url_patroon" value="'^http?://'" />

      <sch:p>Het patroon in data:uri moet overeenkomen met zijn data:soortRef (URL: correcte
        http-ref, AKN: correcte AKN, JCI: correcte JCI)</sch:p>
      <sch:assert id="STOP1021" role="error"
        test="($is_akn and matches(./data:uri/string(), $akn_patroon)) or ($is_jci and matches(./data:uri/string(), $jci_patroon)) or ($is_url and matches(./data:uri/string(), $url_patroon))"
        > {"code": "STOP1021", "substring": "<sch:value-of select="./data:uri/string()" />", "melding": "De uri <sch:value-of select="./data:uri/string()" /> MOET corresponderen met de soortRef (URL: correcte http-ref, AKN: correcte AKN, JCI: correcte JCI). Pas deze aan.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_data_012">
    <sch:title>datum ondertekening verplicht voor off pub van besluit en verboden voor off pub van
      kennisgeving</sch:title>
    <sch:rule
      context="data:OfficielePublicatieMetadata[data:soortPublicatie = '/join/id/stop/soortpublicatie_001']">
      <sch:assert id="STOP1032" test="data:ondertekendOp"> {"code": "STOP1032", "melding": "De officiële publicatie van het besluit heeft geen datum ondertekening.", "ernst": "fout"},</sch:assert>
    </sch:rule>
    <sch:rule
      context="data:OfficielePublicatieMetadata[data:soortPublicatie = '/join/id/stop/soortpublicatie_002']">
      <sch:report id="STOP1033" test="data:ondertekendOp"> {"code": "STOP1033", "melding": "De officiële publicatie van een besluit heeft ten onrechte een datum ondertekening.", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_data_013">
    <sch:title>soortBestuursorgaan gevuld voor decentraal</sch:title>
    <sch:let name="is_decentraal" value="'gemeente|provincie|waterschap'" />
    <sch:rule context="
        data:RegelingMetadata[data:eindverantwoordelijke[matches(., $is_decentraal)]] |
        data:BesluitMetadata[data:eindverantwoordelijke[matches(., $is_decentraal)]]">
      <sch:report id="STOP1034"
        test="not(data:soortBestuursorgaan) or data:soortBestuursorgaan=''">{"code": "STOP1034", "melding": "soortBestuursorgaan MAG NIET leeg zijn voor gemeente, provincie of waterschap. Vul soortBestuursorgaan in.", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="sch_data_014">
    <sch:title>soortBestuursorgaan passend bij eindverantwoordelijke</sch:title>
    <sch:rule context="data:RegelingMetadata|data:BesluitMetadata">

      <sch:let name="is_gemeente" value="matches(./data:eindverantwoordelijke, 'gemeente')" />
      <sch:let name="is_waterschap" value="matches(./data:eindverantwoordelijke, 'waterschap')" />
      <sch:let name="is_provincie" value="matches(./data:eindverantwoordelijke, 'provincie')" />
      <sch:let name="is_staat" value="matches(./data:eindverantwoordelijke, 'ministerie')" />

      <sch:let name="gemeente_bestuursorgaan_patroon" value="'c_2c4e7407|c_28ecfd6d|c_2a7d8663|^$'" />
      <sch:let name="waterschap_bestuursorgaan_patroon"
        value="'c_70c87e3d|c_5cc92c89|c_f70a6113|^$'" />
      <sch:let name="provincie_bestuursorgaan_patroon" value="'c_e24d39f6|c_61676cbc|c_411b4e4a|^$'" />
      <sch:let name="staat_bestuursorgaan_patroon" value="'c_bcfb7b4e|c_91fb5e42|c_3aaa4d12|^$'" />

      <sch:assert id="STOP1035"
        test="
          ($is_gemeente and matches(./data:soortBestuursorgaan, $gemeente_bestuursorgaan_patroon)) or
          ($is_waterschap and matches(./data:soortBestuursorgaan, $waterschap_bestuursorgaan_patroon)) or
          ($is_provincie and matches(./data:soortBestuursorgaan, $provincie_bestuursorgaan_patroon)) or
          ($is_staat and matches(./data:soortBestuursorgaan, $staat_bestuursorgaan_patroon))"
        >{"code": "STOP1035", "melding": "soortBestuursorgaan MOET corresponderen met eindverantwoordelijke. Pas soortBestuursorgaan of eindverantwoordelijke aan.", "ernst": "fout"},</sch:assert>

    </sch:rule>
  </sch:pattern>

</sch:schema>
