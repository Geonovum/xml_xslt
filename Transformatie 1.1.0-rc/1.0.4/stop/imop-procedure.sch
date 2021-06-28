<?xml version="1.0" encoding="UTF-8"?>
<sch:schema queryBinding="xslt2" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <sch:ns prefix="data" uri="https://standaarden.overheid.nl/stop/imop/data/" />
  <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform" />

  <sch:p>Versie 1.0.4</sch:p>
  <sch:p>Schematron voor aanvullende validatie voor procedureverlopen</sch:p>

  <sch:pattern id="sch_proc_001" see="data:Procedureverloop data:Procedureverloopmutatie">
    <sch:title>Unieke stapsoorten</sch:title>
    <sch:rule context="data:Procedureverloop | data:Procedureverloopmutatie">
      <sch:report id="STOP1036" role="error" test="//data:soortStap[.=following::data:soortStap]">
        {"code": "STOP1036", "soortstap": "<sch:value-of select="//data:soortStap[.=following::data:soortStap]" />", "melding": "Er zijn meer dan één procedurestappen met <sch:value-of select="//data:soortStap[.=following::data:soortStap]" /> aangetroffen. Elke stap moet voorzien zijn een unieke soort stap binnen het procedureverloop.", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>

</sch:schema>
