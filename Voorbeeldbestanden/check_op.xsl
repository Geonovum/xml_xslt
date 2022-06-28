<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" version="2.0" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

  <!-- vbCr -->
  <xsl:param name="vbCr" select="string('&#10;')"/>

  <!-- directories -->
  <xsl:param name="base.dir" select="fn:tokenize(fn:base-uri(.),'template.xml')[1]"/>
  <xsl:param name="input.dir" select="concat($base.dir,'input/')"/>
  <xsl:param name="temp.dir" select="concat($base.dir,'temp/')"/>
  <xsl:param name="output.dir" select="concat($base.dir,'output/')"/>

  <!-- namespaces LVBB -->
  <xsl:param name="lvbb" select="string('http://www.overheid.nl/2017/lvbb')"/>
  <!-- namespaces OP -->
  <xsl:param name="data" select="string('https://standaarden.overheid.nl/stop/imop/data/')"/>
  <xsl:param name="tekst" select="string('https://standaarden.overheid.nl/stop/imop/tekst/')"/>
  <xsl:param name="dso" select="string('https://www.dso.nl/')"/>
  <xsl:param name="basisgeo" select="string('http://www.geostandaarden.nl/basisgeometrie/1.0')"/>
  <xsl:param name="geo" select="string('https://standaarden.overheid.nl/stop/imop/geo/')"/>
  <xsl:param name="gio" select="string('https://standaarden.overheid.nl/stop/imop/gio/')"/>
  <xsl:param name="gml" select="string('http://www.opengis.net/gml/3.2')"/>
  <xsl:param name="aan" select="string('https://standaarden.overheid.nl/lvbb/stop/aanlevering/')"/>
  <xsl:param name="uit" select="string('https://standaarden.overheid.nl/stop/imop/uitwisseling/')"/>
  <!-- algemeen -->
  <xsl:param name="xsi" select="string('http://www.w3.org/2001/XMLSchema-instance')"/>

  <!-- matrix -->
  <xsl:param name="matrix" select="document(concat($base.dir,'/matrix.xml'))/matrix"/>

  <!-- waardelijsten -->
  <xsl:param name="waardelijsten" select="document(concat($base.dir,'/waardelijsten OP 1.3.0.xml'))//Waardelijst"/>

  <!-- transformeer OP-bestanden -->
  <xsl:param name="besluit" select="collection(concat($input.dir,'?select=*.xml'))/AanleveringBesluit" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"/>
  <xsl:param name="regeling" select="$besluit//(RegelingCompact,RegelingKlassiek,RegelingMutatie,RegelingTijdelijkdeel,RegelingVrijtekst)" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
  <xsl:param name="ID01" select="fn:tokenize(($besluit//RegelingMetadata/(eindverantwoordelijke,maker))[1],'/')[5]" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
  <xsl:param name="ID02" select="string(($besluit//RegelingVersieMetadata/versienummer)[1])" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
  <xsl:param name="ID03" select="string(($besluit//RegelingMetadata/soortRegeling)[1])" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>

  <!-- maak log -->
  <xsl:param name="log">
    <xsl:element name="soortRegeling">
      <xsl:attribute name="id" select="$matrix/soortRegeling[id=$ID03]/id"/>
      <xsl:attribute name="naam" select="string('soort regeling')"/>
      <xsl:attribute name="waarde" select="$matrix/soortRegeling[id=$ID03]/label"/>
      <xsl:attribute name="structuur" select="$matrix/soortRegeling[id=$ID03]/structuur"/>
    </xsl:element>
    <xsl:element name="typeBesluit">
      <xsl:attribute name="naam" select="string('type besluit')"/>
      <xsl:attribute name="waarde" select="$besluit//element()[local-name()=$matrix/soortRegeling[id=$ID03]/opbouw/indeling/@besluit]/name()"/>
    </xsl:element>
    <xsl:element name="typeRegeling">
      <xsl:attribute name="naam" select="string('type regeling')"/>
      <xsl:attribute name="waarde" select="$regeling[local-name()=$matrix/soortRegeling[id=$ID03]/opbouw/indeling/@regeling]/name()"/>
    </xsl:element>
    <xsl:element name="InleidendeTekst">
      <xsl:attribute name="wId" select="fn:string-join($regeling//tekst:InleidendeTekst/@wId,', ')"/>
    </xsl:element>
    <xsl:element name="Toelichting">
      <xsl:attribute name="wId" select="fn:string-join($regeling//tekst:Bijlage[fn:contains(lower-case(tekst:Kop/tekst:Opschrift),'toelichting')]/@wId,', ')"/>
    </xsl:element>
    <xsl:choose>
      <xsl:when test="$matrix/soortRegeling[id=$ID03]/structuur eq 'artikelstructuur'">
        <xsl:element name="labelHoofdstuk">
          <xsl:attribute name="wId" select="fn:string-join($regeling//tekst:Hoofdstuk[not(fn:contains(lower-case(tekst:Kop/tekst:Label),'hoofdstuk'))]/@wId,', ')"/>
        </xsl:element>
        <xsl:element name="nummerHoofdstuk">
          <xsl:attribute name="wId" select="fn:string-join($regeling//tekst:Hoofdstuk[not(fn:matches(tekst:Kop/tekst:Nummer,'[0-9]+[a-zA-Z]*'))]/@wId,', ')"/>
        </xsl:element>
        <xsl:element name="labelTitel">
          <xsl:attribute name="wId" select="fn:string-join($regeling//tekst:Hoofdstuk/tekst:Titel[not(fn:contains(lower-case(tekst:Kop/tekst:Label),'titel'))]/@wId,', ')"/>
        </xsl:element>
        <xsl:element name="nummerTitel">
          <xsl:variable name="koppen">
            <xsl:for-each select="$regeling//tekst:Titel">
              <xsl:element name="element">
                <xsl:attribute name="wId" select="@wId"/>
                <xsl:for-each select="./(ancestor::tekst:Hoofdstuk)">
                  <xsl:element name="niveau">
                    <xsl:attribute name="index" select="position()"/>
                    <xsl:attribute name="naam" select="name()"/>
                    <xsl:attribute name="nummer" select="fn:tokenize(tekst:Kop/tekst:Nummer,'\.')[last()]"/>
                  </xsl:element>
                </xsl:for-each>
                <xsl:element name="check">
                  <xsl:attribute name="naam" select="name()"/>
                  <xsl:attribute name="nummer" select="fn:tokenize(tekst:Kop/tekst:Nummer,'\.')[last()]"/>
                  <xsl:attribute name="volledig" select="tekst:Kop/tekst:Nummer"/>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:variable>
          <xsl:attribute name="wId" select="fn:string-join($koppen/element[not(fn:starts-with(check/@volledig,fn:string-join(niveau/@nummer,'.'))) or not(fn:matches(check/@nummer,'[0-9]+[a-zA-Z]*'))]/@wId,', ')"/>
        </xsl:element>
        <xsl:element name="labelAfdeling">
          <xsl:attribute name="wId" select="fn:string-join($regeling//tekst:Afdeling[not(fn:contains(lower-case(tekst:Kop/tekst:Label),'afdeling'))]/@wId,', ')"/>
        </xsl:element>
        <xsl:element name="nummerAfdeling">
          <xsl:variable name="koppen">
            <xsl:for-each select="$regeling//tekst:Afdeling">
              <xsl:element name="element">
                <xsl:attribute name="wId" select="@wId"/>
                <xsl:for-each select="./(ancestor::tekst:Hoofdstuk|ancestor::tekst:Titel)">
                  <xsl:element name="niveau">
                    <xsl:attribute name="index" select="position()"/>
                    <xsl:attribute name="naam" select="name()"/>
                    <xsl:attribute name="nummer" select="fn:tokenize(tekst:Kop/tekst:Nummer,'\.')[last()]"/>
                  </xsl:element>
                </xsl:for-each>
                <xsl:element name="check">
                  <xsl:attribute name="naam" select="name()"/>
                  <xsl:attribute name="nummer" select="fn:tokenize(tekst:Kop/tekst:Nummer,'\.')[last()]"/>
                  <xsl:attribute name="volledig" select="tekst:Kop/tekst:Nummer"/>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:variable>
          <xsl:attribute name="wId" select="fn:string-join($koppen/element[not(fn:starts-with(check/@volledig,fn:string-join(niveau/@nummer,'.'))) or not(fn:matches(check/@nummer,'[0-9]+[a-zA-Z]*'))]/@wId,', ')"/>
        </xsl:element>
        <xsl:element name="labelParagraaf">
          <xsl:attribute name="wId" select="fn:string-join($regeling//tekst:Paragraaf[not(fn:contains(lower-case(tekst:Kop/tekst:Label),'paragraaf'))]/@wId,', ')"/>
        </xsl:element>
        <xsl:element name="nummerParagraaf">
          <xsl:variable name="koppen">
            <xsl:for-each select="$regeling//tekst:Paragraaf">
              <xsl:element name="element">
                <xsl:attribute name="wId" select="@wId"/>
                <xsl:for-each select="./(ancestor::tekst:Hoofdstuk|ancestor::tekst:Titel|ancestor::tekst:Afdeling)">
                  <xsl:element name="niveau">
                    <xsl:attribute name="index" select="position()"/>
                    <xsl:attribute name="naam" select="name()"/>
                    <xsl:attribute name="nummer" select="fn:tokenize(tekst:Kop/tekst:Nummer,'\.')[last()]"/>
                  </xsl:element>
                </xsl:for-each>
                <xsl:element name="check">
                  <xsl:attribute name="naam" select="name()"/>
                  <xsl:attribute name="nummer" select="fn:tokenize(tekst:Kop/tekst:Nummer,'\.')[last()]"/>
                  <xsl:attribute name="volledig" select="tekst:Kop/tekst:Nummer"/>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:variable>
          <xsl:attribute name="wId" select="fn:string-join($koppen/element[not(fn:starts-with(check/@volledig,fn:string-join(niveau/@nummer,'.'))) or not(fn:matches(check/@nummer,'[0-9]+[a-zA-Z]*'))]/@wId,', ')"/>
        </xsl:element>
        <xsl:element name="labelSubparagraaf">
          <xsl:attribute name="wId" select="fn:string-join($regeling//tekst:Subparagraaf[not(fn:contains(lower-case(tekst:Kop/tekst:Label),'subparagraaf'))]/@wId,', ')"/>
        </xsl:element>
        <xsl:element name="nummerSubparagraaf">
          <xsl:variable name="koppen">
            <xsl:for-each select="$regeling//tekst:Subparagraaf">
              <xsl:element name="element">
                <xsl:attribute name="wId" select="@wId"/>
                <xsl:for-each select="./(ancestor::tekst:Hoofdstuk|ancestor::tekst:Titel|ancestor::tekst:Afdeling|ancestor::Paragraaf)">
                  <xsl:element name="niveau">
                    <xsl:attribute name="index" select="position()"/>
                    <xsl:attribute name="naam" select="name()"/>
                    <xsl:attribute name="nummer" select="fn:tokenize(tekst:Kop/tekst:Nummer,'\.')[last()]"/>
                  </xsl:element>
                </xsl:for-each>
                <xsl:element name="check">
                  <xsl:attribute name="naam" select="name()"/>
                  <xsl:attribute name="nummer" select="fn:tokenize(tekst:Kop/tekst:Nummer,'\.')[last()]"/>
                  <xsl:attribute name="volledig" select="tekst:Kop/tekst:Nummer"/>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:variable>
          <xsl:attribute name="wId" select="fn:string-join($koppen/element[not(fn:starts-with(check/@volledig,fn:string-join(niveau/@nummer,'.'))) or not(fn:matches(check/@nummer,'[0-9]+[a-zA-Z]*'))]/@wId,', ')"/>
        </xsl:element>
        <xsl:element name="labelSubsubparagraaf">
          <xsl:attribute name="wId" select="fn:string-join($regeling//tekst:Subsubparagraaf[not(fn:contains(lower-case(tekst:Kop/tekst:Label),'subsubparagraaf'))]/@wId,', ')"/>
        </xsl:element>
        <xsl:element name="nummerSubsubparagraaf">
          <xsl:variable name="koppen">
            <xsl:for-each select="$regeling//tekst:Subsubparagraaf">
              <xsl:element name="element">
                <xsl:attribute name="wId" select="@wId"/>
                <xsl:for-each select="./(ancestor::tekst:Hoofdstuk|ancestor::tekst:Titel|ancestor::tekst:Afdeling|ancestor::Paragraaf|ancestor::Subparagraaf)">
                  <xsl:element name="niveau">
                    <xsl:attribute name="index" select="position()"/>
                    <xsl:attribute name="naam" select="name()"/>
                    <xsl:attribute name="nummer" select="fn:tokenize(tekst:Kop/tekst:Nummer,'\.')[last()]"/>
                  </xsl:element>
                </xsl:for-each>
                <xsl:element name="check">
                  <xsl:attribute name="naam" select="name()"/>
                  <xsl:attribute name="nummer" select="fn:tokenize(tekst:Kop/tekst:Nummer,'\.')[last()]"/>
                  <xsl:attribute name="volledig" select="tekst:Kop/tekst:Nummer"/>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:variable>
          <xsl:attribute name="wId" select="fn:string-join($koppen/element[not(fn:starts-with(check/@volledig,fn:string-join(niveau/@nummer,'.'))) or not(fn:matches(check/@nummer,'[0-9]+[a-zA-Z]*'))]/@wId,', ')"/>
        </xsl:element>
        <xsl:element name="labelArtikel">
          <xsl:attribute name="wId" select="fn:string-join($regeling//tekst:Artikel[not(fn:contains(lower-case(tekst:Kop/tekst:Label),'artikel'))]/@wId,', ')"/>
        </xsl:element>
        <xsl:element name="nummerArtikel">
          <xsl:variable name="koppen">
            <xsl:for-each select="$regeling//tekst:Artikel">
              <xsl:element name="element">
                <xsl:attribute name="wId" select="@wId"/>
                <xsl:for-each select="./(ancestor::tekst:Hoofdstuk)">
                  <xsl:element name="niveau">
                    <xsl:attribute name="index" select="position()"/>
                    <xsl:attribute name="naam" select="name()"/>
                    <xsl:attribute name="nummer" select="fn:tokenize(tekst:Kop/tekst:Nummer,'\.')[last()]"/>
                  </xsl:element>
                </xsl:for-each>
                <xsl:element name="check">
                  <xsl:attribute name="naam" select="name()"/>
                  <xsl:attribute name="nummer" select="fn:tokenize(tekst:Kop/tekst:Nummer,'\.')[last()]"/>
                  <xsl:attribute name="volledig" select="tekst:Kop/tekst:Nummer"/>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:variable>
          <xsl:attribute name="wId" select="fn:string-join($koppen/element[not(fn:starts-with(check/@volledig,fn:string-join(niveau/@nummer,'.'))) or not(fn:matches(check/@nummer,'[0-9]+[a-zA-Z]*'))]/@wId,', ')"/>
        </xsl:element>
        <xsl:element name="nummerLid">
          <xsl:attribute name="wId" select="fn:string-join($regeling//tekst:Lid[not(fn:matches(tekst:LidNummer,'[0-9]+'))]/@wId,', ')"/>
        </xsl:element>
        <xsl:element name="LiNummer_genummerd_1">
          <xsl:attribute name="wId" select="fn:string-join($regeling//tekst:Lijst/tekst:Li[($regeling//tekst:Lijst/tekst:Li[tekst:LiNummer ne ((preceding-sibling::tekst:Li|following-sibling::tekst:Li)/tekst:LiNummer)[1]]) and not(fn:matches(tekst:LiNummer,'[a-z]+'))]/@wId,', ')"/>
        </xsl:element>
        <xsl:element name="LiNummer_genummerd_2">
          <xsl:attribute name="wId" select="fn:string-join($regeling//tekst:Lijst/tekst:Li/tekst:Lijst/tekst:Li[($regeling//tekst:Lijst/tekst:Li[tekst:LiNummer ne ((preceding-sibling::tekst:Li|following-sibling::tekst:Li)/tekst:LiNummer)[1]]) and not(fn:matches(tekst:LiNummer,'[0-9]+'))]/@wId,', ')"/>
        </xsl:element>
        <xsl:element name="LiNummer_genummerd_3">
          <xsl:attribute name="wId" select="fn:string-join($regeling//tekst:Lijst/tekst:Li/tekst:Lijst/tekst:Li[($regeling//tekst:Lijst/tekst:Li[tekst:LiNummer ne ((preceding-sibling::tekst:Li|following-sibling::tekst:Li)/tekst:LiNummer)[1]]) and not(fn:matches(tekst:LiNummer,'[ICDLMVX]+'))]/@wId,', ')"/>
        </xsl:element>
        <xsl:for-each select="$regeling//tekst:Begrippenlijst">
          <xsl:variable name="check" as="xs:token*">
            <xsl:perform-sort select=".//tekst:Term">
              <xsl:sort/>
            </xsl:perform-sort>
          </xsl:variable>
          <xsl:variable name="test1" select="fn:string-join(./tekst:Begrip/tekst:Term,'|')"/>
          <xsl:variable name="test2" select="fn:string-join($check,'|')"/>
          <xsl:element name="Begrippenlijst">
            <xsl:attribute name="wId" select="@wId"/>
            <xsl:attribute name="index" select="position()"/>
            <xsl:attribute name="gesorteerd" select="if (fn:string-join(./tekst:Begrip/tekst:Term,'|') eq fn:string-join($check,'|')) then string('wel') else string('niet')"/>
          </xsl:element>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:param>

  <xsl:template match="/">
    <xsl:call-template name="log"/>
    <xsl:call-template name="besluit"/>
  </xsl:template>

  <!-- maak log-bestand -->

  <xsl:template name="log">
    <xsl:result-document href="{concat($temp.dir,'log.txt')}" method="text">
      <xsl:value-of select="concat('check_op.xsl:',$vbCr)"/>
      <xsl:value-of select="concat($vbCr,'[Controle op de structuur van het besluit]',$vbCr)"/>
      <xsl:value-of select="concat('- ','Het ',$log/soortRegeling/@naam,' is ',$log/soortRegeling/@waarde,'.',$vbCr)"/>
      <xsl:value-of select="concat('- ','Het ',$log/typeBesluit/@naam,' is ',if ($log/typeBesluit/@waarde ne '') then $log/typeBesluit/@waarde else 'niet correct','.',$vbCr)"/>
      <xsl:value-of select="concat('- ','Het ',$log/typeRegeling/@naam,' is ',if ($log/typeRegeling/@waarde ne '') then $log/typeRegeling/@waarde else 'niet correct','.',$vbCr)"/>
      <xsl:value-of select="concat($vbCr,'[InleidendeTekst is depricated]',$vbCr)"/>
      <xsl:value-of select="concat('- ','wId van InleidendeTekst is ',if ($log/InleidendeTekst/@wId ne '') then $log/InleidendeTekst/@wId else 'niet gevonden','.',$vbCr)"/>
      <xsl:value-of select="concat($vbCr,'[Controle op AlgemeneToelichting en ArtikelgewijzeToelichting]',$vbCr)"/>
      <xsl:value-of select="concat('- ','wId van Bijlage met Kop ''toelichting'' is ',if ($log/Toelichting/@wId ne '') then $log/Toelichting/@wId else 'niet gevonden','.',$vbCr)"/>
      <xsl:value-of select="concat($vbCr,'[Controle op Hoofdstuk/Kop]',$vbCr)"/>
      <xsl:value-of select="concat('- ','wId van Hoofdstuk met onjuist Kop/Label is ',if ($log/labelHoofdstuk/@wId ne '') then $log/labelHoofdstuk/@wId else 'niet gevonden','.',$vbCr)"/>
      <xsl:value-of select="concat('- ','wId van Hoofdstuk met onjuist Kop/Nummer is ',if ($log/nummerHoofdstuk/@wId ne '') then $log/nummerHoofdstuk/@wId else 'niet gevonden','.',$vbCr)"/>
      <xsl:value-of select="concat($vbCr,'[Controle op Titel/Kop]',$vbCr)"/>
      <xsl:value-of select="concat('- ','wId van Titel met onjuist Kop/Label is ',if ($log/labelTitel/@wId ne '') then $log/labelTitel/@wId else 'niet gevonden','.',$vbCr)"/>
      <xsl:value-of select="concat('- ','wId van Titel met onjuist Kop/Nummer is ',if ($log/nummerTitel/@wId ne '') then $log/nummerTitel/@wId else 'niet gevonden','.',$vbCr)"/>
      <xsl:value-of select="concat($vbCr,'[Controle op Afdeling/Kop]',$vbCr)"/>
      <xsl:value-of select="concat('- ','wId van Afdeling met onjuist Kop/Label is ',if ($log/labelAfdeling/@wId ne '') then $log/labelAfdeling/@wId else 'niet gevonden','.',$vbCr)"/>
      <xsl:value-of select="concat('- ','wId van Afdeling met onjuist Kop/Nummer is ',if ($log/nummerAfdeling/@wId ne '') then $log/nummerAfdeling/@wId else 'niet gevonden','.',$vbCr)"/>
      <xsl:value-of select="concat($vbCr,'[Controle op Paragraaf/Kop]',$vbCr)"/>
      <xsl:value-of select="concat('- ','wId van Paragraaf met onjuist Kop/Label is ',if ($log/labelParagraaf/@wId ne '') then $log/labelParagraaf/@wId else 'niet gevonden','.',$vbCr)"/>
      <xsl:value-of select="concat('- ','wId van Paragraaf met onjuist Kop/Nummer is ',if ($log/nummerParagraaf/@wId ne '') then $log/nummerParagraaf/@wId else 'niet gevonden','.',$vbCr)"/>
      <xsl:value-of select="concat($vbCr,'[Controle op Subparagraaf/Kop]',$vbCr)"/>
      <xsl:value-of select="concat('- ','wId van Subparagraaf met onjuist Kop/Label is ',if ($log/labelSubparagraaf/@wId ne '') then $log/labelSubparagraaf/@wId else 'niet gevonden','.',$vbCr)"/>
      <xsl:value-of select="concat('- ','wId van Subparagraaf met onjuist Kop/Nummer is ',if ($log/nummerSubparagraaf/@wId ne '') then $log/nummerSubparagraaf/@wId else 'niet gevonden','.',$vbCr)"/>
      <xsl:value-of select="concat($vbCr,'[Controle op Subsubparagraaf/Kop]',$vbCr)"/>
      <xsl:value-of select="concat('- ','wId van Subsubparagraaf met onjuist Kop/Label is ',if ($log/labelSubsubparagraaf/@wId ne '') then $log/labelSubsubparagraaf/@wId else 'niet gevonden','.',$vbCr)"/>
      <xsl:value-of select="concat('- ','wId van Subsubparagraaf met onjuist Kop/Nummer is ',if ($log/nummerSubsubparagraaf/@wId ne '') then $log/nummerSubsubparagraaf/@wId else 'niet gevonden','.',$vbCr)"/>
      <xsl:value-of select="concat($vbCr,'[Controle op Artikel/Kop]',$vbCr)"/>
      <xsl:value-of select="concat('- ','wId van Artikel met onjuist Kop/Label is ',if ($log/labelArtikel/@wId ne '') then $log/labelArtikel/@wId else 'niet gevonden','.',$vbCr)"/>
      <xsl:value-of select="concat('- ','wId van Artikel met onjuist Kop/Nummer is ',if ($log/nummerArtikel/@wId ne '') then $log/nummerArtikel/@wId else 'niet gevonden','.',$vbCr)"/>
      <xsl:value-of select="concat($vbCr,'[Controle op Lid/Nummer]',$vbCr)"/>
      <xsl:value-of select="concat('- ','wId van Lid met onjuist LidNummer is ',if ($log/nummerLid/@wId ne '') then $log/nummerLid/@wId else 'niet gevonden','.',$vbCr)"/>
      <xsl:value-of select="concat($vbCr,'[Controle op LiNummer van genummerde lijsten, niveau 1]',$vbCr)"/>
      <xsl:value-of select="concat('- ','wId van Li met onjuist LiNummer is ',if ($log/LiNummer_genummerd_1/@wId ne '') then $log/LiNummer_genummerd_1/@wId else 'niet gevonden','.',$vbCr)"/>
      <xsl:value-of select="concat($vbCr,'[Controle op LiNummer van genummerde lijsten, niveau 2]',$vbCr)"/>
      <xsl:value-of select="concat('- ','wId van Li met onjuist LiNummer is ',if ($log/LiNummer_genummerd_2/@wId ne '') then $log/LiNummer_genummerd_2/@wId else 'niet gevonden','.',$vbCr)"/>
      <xsl:value-of select="concat($vbCr,'[Controle op LiNummer van genummerde lijsten, niveau 3]',$vbCr)"/>
      <xsl:value-of select="concat('- ','wId van Li met onjuist LiNummer is ',if ($log/LiNummer_genummerd_3/@wId ne '') then $log/LiNummer_genummerd_3/@wId else 'niet gevonden','.',$vbCr)"/>
      <xsl:for-each select="$log/Begrippenlijst">
        <xsl:value-of select="concat('- ','Begrippenlijst met wId ',./@wId,' is ',./@gesorteerd,' gesorteerd.',$vbCr)"/>
      </xsl:for-each>
    </xsl:result-document>
  </xsl:template>

  <!-- transformeer besluit -->

  <xsl:template name="besluit">
    <xsl:apply-templates select="$besluit"/>
  </xsl:template>

  <xsl:template match="AanleveringBesluit" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
    <xsl:element name="{name()}" namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
      <xsl:attribute name="schemaversie" select="string('1.2.0')"/>
      <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('https://standaarden.overheid.nl/lvbb/stop/aanlevering https://standaarden.overheid.nl/lvbb/1.2.0/lvbb-stop-aanlevering.xsd')"/>
      <!-- geef informatie door aan AKN.xsl -->
      <xsl:processing-instruction name="akn">
        <xsl:value-of select="fn:string-join(($ID01,$ID02),'_')"/>
      </xsl:processing-instruction>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <!-- InleidendeTekst -->

  <xsl:template match="tekst:InleidendeTekst">
    <xsl:element name="Divisietekst" namespace="{$tekst}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="tekst:Kop"/>
      <xsl:element name="Inhoud" namespace="{$tekst}">
        <xsl:apply-templates select="element() except tekst:Kop"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- Algemene templates -->

  <xsl:template match="element()">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()">
    <xsl:copy-of select="."/>
  </xsl:template>

</xsl:stylesheet>