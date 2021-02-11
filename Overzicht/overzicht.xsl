<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
	xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:da="http://www.geostandaarden.nl/imow/datatypenalgemeen" xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0"
	xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:k="http://www.geostandaarden.nl/imow/kaart" xmlns:l="http://www.geostandaarden.nl/imow/locatie"
	xmlns:r="http://www.geostandaarden.nl/imow/regels" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:gio="https://standaarden.overheid.nl/stop/imop/gio/"
	xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="http://mijn.eigen.ns"
	xmlns:ow="http://www.geostandaarden.nl/imow/owobject" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst"
	xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:p="http://www.geostandaarden.nl/imow/pons" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="#all">

	<xsl:output method="html" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:variable name="elError">
		<xsl:element name="Error">Error</xsl:element>
	</xsl:variable>


	<xsl:param name="opdracht.dir" select="''"/>
	<xsl:param name="besluit" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))/AanleveringBesluit"
		xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"/>
	<xsl:param name="divisies" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//vt:Divisie"/>
	<xsl:param name="tekstdelen" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//vt:Tekstdeel"/>

	<xsl:param name="regelteksten" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//r:Regeltekst"/>
	<xsl:param name="regels" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//(r:Instructieregel, r:Omgevingswaarderegel, r:RegelVoorIedereen)"/>
	<xsl:param name="locaties" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//(l:Gebiedengroep, l:Gebied)"/>
	<xsl:param name="activiteiten" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//rol:Activiteit"/>
	<xsl:param name="gebiedsaanwijzingen" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//ga:Gebiedsaanwijzing"/>
	<xsl:param name="omgevingsnormaanduidingen" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//rol:Omgevingsnorm"/>
	<xsl:param name="omgevingswaardeaanduidingen" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//rol:Omgevingswaarde"/>
	<xsl:param name="hoofdlijnaanduidingen" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//vt:Hoofdlijn"/>
	<xsl:param name="kaarten" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//k:Kaart"/>
	<xsl:param name="gml2" select="collection(concat('', $opdracht.dir, '?select=*.gml;recurse=yes'))//basisgeo:id"/>

	<xsl:param name="gml">
		<xsl:for-each select="collection(concat('', $opdracht.dir, '?select=*.gml;recurse=yes'))">
			<!--		<xsl:for-each select="collection(concat('file:/', $opdracht.dir, '?select=*.gml;recurse=yes'))">-->
			<xsl:element name="Locatie">
				<xsl:attribute name="bestand" select="fn:tokenize(fn:document-uri(.), '/')[last()]"/>
				<xsl:attribute name="join-id" select="./descendant::geo:FRBRExpression"/>
				<xsl:attribute name="geo-id" select="fn:string-join(./descendant::basisgeo:id, ', ')"/>
				<xsl:for-each select="./descendant::basisgeo:id">
					<xsl:element name="geo-idEl">
						<xsl:value-of select="string(.)"/>
					</xsl:element>
				</xsl:for-each>


				<!-- hier kunnen foutmeldingen in -->
			</xsl:element>
		</xsl:for-each>
	</xsl:param>



	<xsl:param name="waardelijsten" select="document('waardelijsten OP 1.0.4.xml')//Waardelijst"/>

	<xsl:template match="/">
		<html>
			<head>
				<script src="../cssScriptWim/jquery-3.5.1.js"/>
				<script src="../cssScriptWim/grondCheck.js"/>
				<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
				<link rel="stylesheet" type="text/css" href="../cssScriptWim/overzicht.css"/>
				<title>
					<xsl:apply-templates select="$besluit//BesluitMetadata/officieleTitel/node()" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
				</title>
			</head>
			<body>
				<div>
					<ul id="menu">
						<li id="Item1"> </li>
						<li id="Item2">
							<span href="http://www.somewhere.com" onmouseover="OpenMenu('Item2Submenu')">OW objecten</span>
							<ul id="Item2Submenu" onmouseover="KeepSubmenu()" onmouseout="CloseMenu()">
								<span onclick="fetch(['r:RegelVoorIedereen']);">Regel(s)VoorIedereen</span>
								<span onclick="fetch(['GIO']);">GIO's</span>
								<span onclick="fetch(['l:Gebied','l:Lijn', 'l:Punt']);">Gebieden, Lijnen en Punten</span>
								<span onclick="fetch(['l:Gebiedengroep','l:Lijnengroep', 'l:Puntengroep']);">l:Gebiedengroepen Lijnengroepen Puntengroepen</span>
								<span onclick="fetch(['GML']);">GML's</span>
								<span onclick="fetch(['rol:Activiteit']);">Activiteiten</span>
								<span onclick="fetch(['ga:Gebiedsaanwijzing']);">Gebiedsaanwijzingen</span>
<!--								<span onclick="maakrelaties('maakRelaties');">maakRelaties</span>-->
								<span onclick="fetch(['k:Kaart']);">Kaarten</span>
								<span onclick="fetch(['rol:Omgevingsnorm']);">Omgevingsnormen</span>
								<span onclick="fetch(['rol:Omgevingswaarde']);">Omgevingswaarden</span>
								<span onclick="fetch(['p:Pons']);">Ponsen</span>
								<span onclick="fetch(['rg:Regelingsgebied']);">Regelingsgebieden</span>
								<span onclick="fetch(['r:Instructieregel']);">Instructieregels</span>
								<span onclick="fetch(['r:Omgevingswaarderegel']);">Omgevingswaarderegels</span>
							</ul>
						</li>
					</ul>
				</div>
				<div class="divMain">
					<!--					<svg xmlns="http://www.w3.org/2000/svg" width="400" height="400" viewBox="0 0 400 400">
						<defs>
							<marker id="arrow" markerWidth="10" markerHeight="10" refX="0" refY="2" orient="auto" markerUnits="strokeWidth">
								<path d="M0,0 L0,4 L7,2 z" fill="#f00"/>
							</marker>
						</defs>
						<line x1="0" y1="40" x2="245" y2="40" stroke="#f00" stroke-width="2" marker-end="url(#arrow)"/>
					</svg>-->



					<!--**************OW-OBJECTEN*************-->


					<!--zie OWobjectSjaboon.xml voor een template-->



					<div class="divOW" id="1">


						<xsl:comment>************* r:RegelVoorIedereen *************** </xsl:comment>

						<!--r:RegelVoorIedereen-->

						<xsl:for-each select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//r:RegelVoorIedereen">
							<xsl:variable name="ref2Regeltekst" select="string(./r:artikelOfLid/r:RegeltekstRef/@xlink:href)"/>
							<xsl:variable name="r_identificatie" select="//ow-dc:owObject/r:Regeltekst/r:identificatie[string(self::node()) eq $ref2Regeltekst]"/>
							<!--<xsl:message select="$ref2Regeltekst"/>-->
							<!--wId vd de OPregel = data-target-->
							<xsl:variable name="wIdRechtsRegel" select="string($r_identificatie/parent::r:Regeltekst/@wId)"/>
							<xsl:variable name="r:identificatie" select="string(./r:identificatie)"/>
							<table class="owTable">
								<tr>
									<td>
										<div id="{$r:identificatie}" data-target="{$wIdRechtsRegel}" data-xml="r:RegelVoorIedereen" class="owObject">
											<div class="owHead">
												<span class="objectTitel" ondblclick="ShowHideOW(this)">RegelVoorIedereen</span>
												<span class="highLight" onClick="openCloseOWobj(this)">  ...  </span>
												<span class="default" onClick="geefInkomendeRelaties(this)"> inkomende relaties </span>
												<!--												<span class="highLight" onClick="toonRelaties(this)"> meer relaties</span>-->
												<br/>
												<span class="entry" onClick="showOpLink(this, '{($wIdRechtsRegel)}')">Artikel of lid (via r:Regeltekst) = <span class="link" data-target="{string($wIdRechtsRegel)}"><xsl:value-of
															select="string($wIdRechtsRegel)"/></span></span>
												<br/>
												<span class="entry">r:identificatie = <xsl:value-of select="$r:identificatie"/></span>
											</div>
											<div class="owFields">
												<xsl:if test="./ow:status">
													<span class="entry">ow:status = <xsl:value-of select="string(./ow:status)"/></span>
													<br/>
												</xsl:if>
												<xsl:if test="./ow:procedurestatus">
													<span class="entry">ow:procedurestatus = <xsl:value-of select="string(./ow:procedurestatus)"/></span>
													<br/>
												</xsl:if>
												<span class="entry"><xsl:value-of select="name(./r:idealisatie)"/> = <xsl:value-of select="string(./r:idealisatie)"/></span>
												<br/>
												<xsl:for-each select="./r:thema">
													<span class="entry"><xsl:value-of select="name(.)"/> = <xsl:value-of select="string(.)"/></span>
													<br/>
												</xsl:for-each>
												<br/>
												<xsl:for-each select="./r:activiteitaanduiding">
													<span class="entry">r:activiteitaanduiding/rol:ActiviteitRef = <span class="link" data-target="{string(./rol:ActiviteitRef/@xlink:href)}"
															onClick="showLink('{$r:identificatie}','{(./rol:ActiviteitRef/@xlink:href)}')"><xsl:value-of select="string(./rol:ActiviteitRef/@xlink:href)"/></span></span>
													<br/>
													<xsl:for-each select="./r:ActiviteitLocatieaanduiding/element()">
														<xsl:choose>
															<xsl:when test="name(.) eq 'r:locatieaanduiding'">
																<span class="entry">r:activiteitaanduiding/r:ActiviteitLocatieaanduiding/r:locatieaanduiding/l:LocatieRef<xsl:text> = </xsl:text>
																	<span class="link" data-target="{string(./l:LocatieRef/@xlink:href)}" onClick="showLink('{$r:identificatie}','{(./l:LocatieRef/@xlink:href)}')"><xsl:value-of
																			select="./l:LocatieRef/@xlink:href"/>
																	</span>
																</span>
																<br/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:variable name="ref" select="string(.)"/>
																<xsl:if test="./@id">
																	<span class="entry">id = <xsl:value-of select="string(./@id)"/></span>
																	<br/>
																</xsl:if>
																<span class="entry">r:activiteitaanduiding/r:ActiviteitLocatieaanduiding/<xsl:value-of select="name(.)"/> = <span><xsl:value-of select="$ref"/></span></span>
																<br/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:for-each>
													<br/>
												</xsl:for-each>


												<xsl:for-each select="./r:gebiedsaanwijzing/ga:GebiedsaanwijzingRef">
													<span class="entry">r:gebiedsaanwijzing/ga:GebiedsaanwijzingRef = <span class="link" data-target="{string(@xlink:href)}" onClick="showLink('{$r:identificatie}','{(@xlink:href)}')"
																><xsl:value-of select="string(@xlink:href)"/></span></span>
													<br/>
												</xsl:for-each>

												<xsl:for-each select="./r:kaartaanduiding/k:KaartRef">
													<span class="entry">r:kaartaanduiding/k:KaartRef = <span class="link" data-target="{string(@xlink:href)}" onClick="showLink('{$r:identificatie}','{(@xlink:href)}')"><xsl:value-of
																select="string(@xlink:href)"/></span></span>
													<br/>
												</xsl:for-each>
												<xsl:for-each select="./r:omgevingsnormaanduiding/rol:OmgevingsnormRef">
													<span class="entry">r:omgevingsnormaanduiding/rol:OmgevingsnormRef<xsl:value-of select="name(.)"/> = 
											<span class="link" data-target="{string(@xlink:href)}"
															onClick="showLink('{$r:identificatie}','{(@xlink:href)}')"/><xsl:value-of select="string(@xlink:href)"/>
													</span>
													<br/>
												</xsl:for-each>

											</div>
										</div>
										<!-- inline div met gerelateerde  objecten -->
									</td>
									<td/>
								</tr>
							</table>
						</xsl:for-each>


						<xsl:comment>************* r:Instructieregel *************** </xsl:comment>

						<!--r:Instructieregel-->

						<xsl:for-each select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//r:Instructieregel">
							<xsl:variable name="ref2Regeltekst" select="string(./r:artikelOfLid/r:RegeltekstRef/@xlink:href)"/>
							<xsl:variable name="r_identificatie" select="./ancestor::sl:stand/preceding-sibling::sl:stand/ow-dc:owObject/r:Regeltekst/r:identificatie[string(self::node()) eq $ref2Regeltekst]"/>
							<!--wId vd de OPregel = data-target-->
							<xsl:variable name="wIdRechtsRegel" select="string($r_identificatie/parent::r:Regeltekst/@wId)"/>
							<xsl:variable name="r:identificatie" select="string(./r:identificatie)"/>

							<table class="owTable">
								<tr>
									<td>
										<div id="{$r:identificatie}" data-target="{$wIdRechtsRegel}" data-xml="r:Instructieregel" class="owObject">
											<div class="owHead">
												<span class="objectTitel" ondblclick="ShowHideOW(this)">Instructieregel</span>
												<span class="highLight" onClick="openCloseOWobj(this)"> ... </span>
												<span class="default" onClick="geefInkomendeRelaties(this)"> inkomende relaties </span>
												<br/>
												<span class="entry" onClick="showOpLink(this, '{($wIdRechtsRegel)}')">Artikel of lid (via r:Regeltekst) = <span class="link" data-target="{$wIdRechtsRegel}"><xsl:value-of
															select="string($wIdRechtsRegel)"/></span></span>
												<br/>
												<span class="entry">r:identificatie = <xsl:value-of select="$r:identificatie"/></span>
											</div>

											<div class="owFields">
												<span class="entry"><xsl:value-of select="name(./r:idealisatie)"/> = <xsl:value-of select="string(./r:idealisatie)"/></span>
												<br/>
												<xsl:for-each select="./r:thema">
													<span class="entry"><xsl:value-of select="name(.)"/> = <xsl:value-of select="string(.)"/></span>
													<br/>
												</xsl:for-each>
												<xsl:for-each select="./r:locatieaanduiding/l:LocatieRef">
													<span class="entry">r:locatieaanduiding/l:LocatieRef = <span class="link" data-target="{string(@xlink:href)}" onClick="showLink('{$r:identificatie}','{(@xlink:href)}')"><xsl:value-of
																select="string(@xlink:href)"/></span></span>
													<br/>
												</xsl:for-each>
												<xsl:if test="./ow:status">
													<span class="entry">ow:status = <xsl:value-of select="string(./ow:status)"/></span>
													<br/>
												</xsl:if>
												<xsl:if test="./ow:procedurestatus">
													<span class="entry">ow:procedurestatus = <xsl:value-of select="string(./ow:procedurestatus)"/></span>
													<br/>
												</xsl:if>
												<xsl:for-each select="./r:gebiedsaanwijzing/ga:GebiedsaanwijzingRef">
													<span class="entry">r:gebiedsaanwijzing/ga:GebiedsaanwijzingRef = <span class="link" data-target="{string(@xlink:href)}" onClick="showLink('{$r:identificatie}','{(@xlink:href)}')"
															/><xsl:value-of select="string(@xlink:href)"/></span>
													<br/>
												</xsl:for-each>
												<xsl:for-each select="./r:kaartaanduiding/k:KaartRef">
													<span class="entry">r:kaartaanduiding/k:KaartRef = <span class="link" data-target="{string(@xlink:href)}" onClick="showLink('{$r:identificatie}','{(@xlink:href)}')"><xsl:value-of
																select="string(@xlink:href)"/></span></span>
													<br/>
												</xsl:for-each>
												<xsl:for-each select="./r:instructieregelInstrument">
													<span class="entry">
														<xsl:value-of select="string(./local-name())"/>
														<xsl:text> = </xsl:text>
														<span>
															<xsl:value-of select="string(.)"/>
														</span>
													</span>
													<br/>
												</xsl:for-each>
												<xsl:for-each select="./r:instructieregelTaakuitoefening">
													<span class="entry">
														<xsl:value-of select="string(./local-name())"/>
														<xsl:text> = </xsl:text>
														<span>
															<xsl:value-of select="string(.)"/>
														</span>
													</span>
													<br/>
												</xsl:for-each>
												<xsl:for-each select="./r:omgevingsnormaanduiding/rol:OmgevingsnormRef">
													<span class="entry">r:omgevingsnormaanduiding/rol:OmgevingsnormRef<xsl:value-of select="name(.)"/> = 
											<span class="link" data-target="{string(@xlink:href)}"
															onClick="showLink('{$r:identificatie}','{(@xlink:href)}')"/><xsl:value-of select="string(@xlink:href)"/>
													</span>
													<br/>
												</xsl:for-each>
											</div>
										</div>
										<!-- inline div met gerelateerde  objecten -->
									</td>
									<td/>
								</tr>
							</table>
						</xsl:for-each>





						<xsl:comment>************* r:Omgevingswaarderegel *************** </xsl:comment>

						<!--r:RegelVoorIedereen-->

						<xsl:for-each select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//r:Omgevingswaarderegel">
							<xsl:variable name="ref2Regeltekst" select="string(./r:artikelOfLid/r:RegeltekstRef/@xlink:href)"/>
							<xsl:variable name="r_identificatie" select="./ancestor::sl:stand/preceding-sibling::sl:stand/ow-dc:owObject/r:Regeltekst/r:identificatie[string(self::node()) eq $ref2Regeltekst]"/>
							<!--wId vd de OPregel = data-target-->
							<xsl:variable name="wIdRechtsRegel" select="string($r_identificatie/parent::r:Regeltekst/@wId)"/>
							<xsl:variable name="r:identificatie" select="string(./r:identificatie)"/>

							<table class="owTable">
								<tr>
									<td>
										<div id="{$r:identificatie}" data-target="{$wIdRechtsRegel}" data-xml="r:Omgevingswaarderegel" class="owObject">
											<div class="owHead">
												<span class="objectTitel" ondblclick="ShowHideOW(this)">Omgevingswaarderegel</span>
												<span class="highLight" onClick="openCloseOWobj(this)"> ... </span>
												<span class="default" onClick="geefInkomendeRelaties(this)"> inkomende relaties </span>
												<br/>
												<span class="entry" onClick="showOpLink(this, '{($wIdRechtsRegel)}')">Artikel of lid (via r:Regeltekst) = <span class="link" data-target="{$wIdRechtsRegel}"><xsl:value-of
															select="string($wIdRechtsRegel)"/></span></span>
												<br/>
												<span class="entry">r:identificatie = <xsl:value-of select="$r:identificatie"/></span>
											</div>

											<div class="owFields">

												<span class="entry"><xsl:value-of select="name(./r:idealisatie)"/> = <xsl:value-of select="string(./r:idealisatie)"/></span>
												<br/>
												<xsl:for-each select="./r:thema">
													<span class="entry"><xsl:value-of select="name(.)"/> = <xsl:value-of select="string(.)"/></span>
													<br/>
												</xsl:for-each>
												<xsl:for-each select="./r:locatieaanduiding/l:LocatieRef">
													<span class="entry">r:locatieaanduiding/l:LocatieRef = <span class="link" data-target="{string(@xlink:href)}" onClick="showLink('{$r:identificatie}','{(@xlink:href)}')"><xsl:value-of
																select="string(@xlink:href)"/></span></span>
													<br/>
												</xsl:for-each>
												<xsl:if test="./ow:status">
													<span class="entry">ow:status = <xsl:value-of select="string(./ow:status)"/></span>
													<br/>
												</xsl:if>
												<xsl:if test="./ow:procedurestatus">
													<span class="entry">ow:procedurestatus = <xsl:value-of select="string(./ow:procedurestatus)"/></span>
													<br/>
												</xsl:if>
												<xsl:for-each select="./r:gebiedsaanwijzing/ga:GebiedsaanwijzingRef">
													<span class="entry">r:gebiedsaanwijzing/ga:GebiedsaanwijzingRef = <span class="link" data-target="{string(@xlink:href)}" onClick="showLink('{$r:identificatie}','{(@xlink:href)}')"
															/><xsl:value-of select="string(@xlink:href)"/></span>
													<br/>
												</xsl:for-each>
												<xsl:for-each select="./r:kaartaanduiding/k:KaartRef">
													<span class="entry">r:kaartaanduiding/k:KaartRef = <span class="link" data-target="{string(@xlink:href)}" onClick="showLink('{$r:identificatie}','{(@xlink:href)}')"><xsl:value-of
																select="string(@xlink:href)"/></span></span>
													<br/>
												</xsl:for-each>


												<xsl:for-each select="./r:omgevingswaardeaanduiding/rol:OmgevingswaardeRef">
													<span class="entry">r:omgevingsnormaanduiding/rol:OmgevingsnormRef<xsl:value-of select="name(.)"/> = 
											<span class="link" data-target="{string(@xlink:href)}"
															onClick="showLink('{$r:identificatie}','{(@xlink:href)}')"/><xsl:value-of select="string(@xlink:href)"/>
													</span>
													<br/>
												</xsl:for-each>
											</div>
										</div>
										<!-- inline div met gerelateerde  objecten -->
									</td>
									<td/>
								</tr>
							</table>
						</xsl:for-each>







						<xsl:comment>************* l:Gebieden/Lijnen/Puntengroep *************** </xsl:comment>
						<!--l:Gebieden/Lijnen/Puntengroep-->

						<xsl:for-each select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//(l:Gebiedengroep | l:Lijnengroep | l:Puntengroep)">
							<!--l:gebied-->
							<xsl:variable name="l:identificatie" select="string(./l:identificatie)"/>
							<table class="owTable">
								<tr>
									<td>

										<div id="{$l:identificatie}" data-xml="{string(./name())}" class="owObject">
											<div class="owHead">
												<span class="objectTitel" ondblclick="ShowHideOW(this)">
													<xsl:value-of select="string(./local-name())"/>
												</span>
												<span class="highLight" onClick="openCloseOWobj(this)"> ... </span>
												<span class="default" onClick="geefInkomendeRelaties(this)"> inkomende relaties </span>
												<br/>
												<span class="entry">l:identificatie = <xsl:value-of select="string($l:identificatie)"/>
												</span>
												<br/>
												<xsl:if test="./l:noemer">
													<span class="entry"><xsl:value-of select="name(./l:noemer)"/> = <xsl:value-of select="string(./l:noemer)"/>
													</span>
												</xsl:if>
											</div>

											<div class="owFields">
												<xsl:for-each select=".//element()[@xlink:href]">
													<span class="entry" data-target="{string(@xlink:href)}">
														<xsl:value-of select="string(./local-name())"/> = 
											<span class="link" data-target="{string(@xlink:href)}" onClick="showLink('{$l:identificatie}','{(@xlink:href)}')">
															<xsl:value-of select="string(@xlink:href)"/>
														</span>
														<br/>
													</span>
												</xsl:for-each>
											</div>
										</div>
									</td>
									<td/>
								</tr>
							</table>
						</xsl:for-each>

						<xsl:comment>************* l:Gebied/lijn/punt *************** </xsl:comment>
						<!--l:Gebied/lijn/punt-->

						<xsl:for-each select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//(l:Gebied | l:Lijn | l:Punt)">
							<xsl:variable name="l:identificatie" select="./l:identificatie"/>
							<table class="owTable">
								<tr>
									<td>

										<div id="{ $l:identificatie}" data-xml="{string(name(.))}" class="owObject">
											<div class="owHead">
												<span class="objectTitel" ondblclick="ShowHideOW(this)">
													<xsl:value-of select="string(./local-name())"/>
												</span>
												<span class="highLight" onClick="openCloseOWobj(this)"> ... </span>
												<span class="default" onClick="geefInkomendeRelaties(this)"> inkomende relaties </span>
												<br/>
												<span class="entry">l:identificatie = <xsl:value-of select="string(./l:identificatie)"/></span>
												<br/>
												<xsl:if test="./l:noemer">
													<span class="entry"><xsl:value-of select="name(./l:noemer)"/> = <xsl:value-of select="string(./l:noemer)"/>
													</span>
												</xsl:if>
											</div>
											<div class="owFields">
												<!--									Locatie @bestand @join-id @geo-id-->
												<xsl:for-each select="./l:geometrie/l:GeometrieRef">
													<xsl:variable name="xlinkhref" select="string(./@xlink:href)"/>
													<xsl:for-each select="$gml2">
														<xsl:for-each select=".">
															<xsl:if test="string(.) eq $xlinkhref">
																<span class="entry">l:GeometrieRef (via GML)= 
																	<span class="link" data-target="{string(.)}" onClick="showLink('{$l:identificatie}','{string(.)}')"
																			><xsl:value-of select="$xlinkhref"/>
																	</span><!-- de link gaat niet naar de GUID, maar het parent GML object -->
																	<br/>
																</span>
															</xsl:if>
														</xsl:for-each>
													</xsl:for-each>

												</xsl:for-each>
												<xsl:if test="./l:hoogte">
													<span class="entry">l:hoogte = <xsl:value-of select="string(./l:hoogte)"/></span>
													<br/>
													<span class="entry">da:waarde = <xsl:value-of select="string(./l:hoogte/@da:waarde)"/></span>
													<br/>
													<span class="entry">da:eenheid = <xsl:value-of select="string(./l:hoogte/@da:eenheid)"/></span>
													<br/>
												</xsl:if>
												<xsl:if test="./ow:status">
													<span class="entry">ow:status = <xsl:value-of select="string(./ow:status)"/></span>
													<br/>
												</xsl:if>
												<xsl:if test="./ow:procedurestatus">
													<span class="entry">ow:procedurestatus = <xsl:value-of select="string(./ow:procedurestatus)"/></span>
													<br/>
												</xsl:if>
											</div>

										</div>
									</td>
									<td/>
								</tr>
							</table>
						</xsl:for-each>

						<!-- vt:gebiedsaanwijzing  -->

						<!--						
						ga: identificatie,  type, naam, groep, specifiekeSymbolisatie?, locatieaanduiding(l:LocatieRef@xlink:href+, l:GebiedRef@xlink:href+, l:GebiedengroepRef@xlink:href+, l:PuntRef@xlink:href+, l:PuntengroepRef@xlink:href+, l:LijnengroepRef@xlink:href+, l:LijnRef@xlink:href+, l:AmbtsgebiedRef@xlink:href+)
						ow:status? ow:procedurestatus?-->

						<xsl:comment>************* ga:gebiedsaanwijzing *************** </xsl:comment>
						<xsl:for-each select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//(ga:Gebiedsaanwijzing)">
							<xsl:variable name="ga:identificatie" select="./ga:identificatie"/>
							<table class="owTable">
								<tr>
									<td>
										<div id="{$ga:identificatie}" data-xml="ga:Gebiedsaanwijzing" class="owObject">
											<div class="owHead">
												<span class="objectTitel" ondblclick="ShowHideOW(this)">
													<xsl:value-of select="string(./local-name())"/>
												</span>
												<span class="highLight" onClick="openCloseOWobj(this)"> ... </span>
												<span class="default" onClick="geefInkomendeRelaties(this)"> inkomende relaties </span>
												<br/>
												<span class="entry">ga:naam = <span><xsl:value-of select="string(./ga:naam)"/></span></span>
												<br/>
											</div>
											<div class="owFields">
												<span class="entry">ga:identificatie = <xsl:value-of select="string(./ga:identificatie)"/></span>
												<br/>
												<span class="entry">ga:type = <xsl:value-of select="string(./ga:type)"/></span>
												<br/>
												<span class="entry">ga:groep = <xsl:value-of select="string(./ga:groep)"/></span>
												<br/>
												<xsl:if test="./ga:specifiekeSymbolisatie">
													<span class="entry">ga:specifiekeSymbolisatie = <xsl:value-of select="string(./ga:specifiekeSymbolisatie)"/></span>
													<br/>
												</xsl:if>
												<xsl:for-each select="./ga:locatieaanduiding/element()">
													<span class="entry">
														<xsl:value-of select="string(./local-name())"/>
														<xsl:text> = </xsl:text>
														<span class="link" data-target="{string(./@xlink:href)}" onClick="showLink('{$ga:identificatie}','{(./@xlink:href)}')">
															<xsl:value-of select="./@xlink:href"/>
														</span>
													</span>
													<br/>
												</xsl:for-each>
												<xsl:if test="./ow:status">
													<span class="entry">ow:status = <xsl:value-of select="string(./ow:status)"/></span>
													<br/>
												</xsl:if>
												<xsl:if test="./ow:procedurestatus">
													<span class="entry">ow:procedurestatus = <xsl:value-of select="string(./ow:procedurestatus)"/></span>
													<br/>
												</xsl:if>
											</div>
										</div>
									</td>
									<td/>
								</tr>
							</table>

						</xsl:for-each>



						<!--						rol:Activiteit
rol:identificatie, naam, groep, gerelateerdeActiviteit?, bovenliggendeActiviteit/ActiviteitRef   						
ow:status? ow:procedurestatus?


            <rol:Activiteit>
               <rol:identificatie>nl.imow-gm0297.activiteit.2019000241</rol:identificatie>
               <rol:naam>uitoefenen van bedrijfstypen van categorie 2</rol:naam>
               <rol:groep>http://standaarden.omgevingswet.overheid.nl/activiteit/id/concept/MilieubelastendeActiviteit</rol:groep>
               <rol:bovenliggendeActiviteit>
                  <rol:ActiviteitRef xlink:href="nl.imow-gm0297.activiteit.topactiviteitomgevingsplan"/>

               </rol:bovenliggendeActiviteit>
            </rol:Activiteit>
-->

						<xsl:comment>************* rol:Activiteit *************** </xsl:comment>
						<xsl:for-each select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//(rol:Activiteit)">
							<xsl:variable name="rol:identificatie" select="./rol:identificatie"/>
							<table class="owTable">
								<tr>
									<td>
										<div id="{$rol:identificatie}" data-xml="rol:Activiteit" class="owObject">
											<div class="owHead">
												<span class="objectTitel" ondblclick="ShowHideOW(this)">
													<xsl:value-of select="string(./local-name())"/>
												</span>
												<span class="highLight" onClick="openCloseOWobj(this)"> ... </span>
												<span class="default" onClick="geefInkomendeRelaties(this)"> inkomende relaties </span>
												<br/>
												<span class="entry">rol:naam = <span><xsl:value-of select="string(./rol:naam)"/></span>
												</span>
												<br/>
											</div>
											<div class="owFields">
												<span class="entry">rol:identificatie = <xsl:value-of select="string(./rol:identificatie)"/></span>
												<br/>
												<span class="entry">rol:groep = <xsl:value-of select="string(./rol:groep)"/></span>
												<br/>
												<xsl:if test="./rol:gerelateerdeActiviteit">
													<span class="entry">rol:gerelateerdeActiviteit = <xsl:value-of select="string(./rol:gerelateerdeActiviteit)"/></span>
													<br/>
												</xsl:if>
												<xsl:for-each select="./rol:bovenliggendeActiviteit/rol:ActiviteitRef/element()">
													<span class="entry">
														<xsl:value-of select="string(./local-name())"/>
														<xsl:text> = </xsl:text>
														<span class="link" data-target="{string(./@xlink:href)}" onClick="showLink('{$rol:identificatie}','{(./@xlink:href)}')">
															<xsl:value-of select="./@xlink:href"/>
														</span>
													</span>
													<br/>
												</xsl:for-each>
												<xsl:if test="./ow:status">
													<span class="entry">ow:status = <xsl:value-of select="string(./ow:status)"/></span>
													<br/>
												</xsl:if>
												<xsl:if test="./ow:procedurestatus">
													<span class="entry">ow:procedurestatus = <xsl:value-of select="string(./ow:procedurestatus)"/></span>
													<br/>
												</xsl:if>
											</div>
										</div>
									</td>
									<td/>
								</tr>
							</table>

						</xsl:for-each>


						<!--	k:Kaart					
						@id?
						ow:status? ow:procedurestatus?
						k:identificatie, naam, nummer?, 
						uitsnede/Kaartextent/(minX, maxX, minY, maxY), 
						kaartlagen
						   Kaartlaag+
						       ow:status? ow:procedurestatus?
						       identificatie
						       naam?
						       niveau
						       activiteitlocatieweergave?/@xlink:href
						       normweergave+
						          rol:NormRef+(@type , @xlink:href)
						          rol:OmgevingsnormRef+(@type , @xlink:href)
						          rol:OmgevingswaardeRef+(@type , @xlink:href)
						       gebiedsaanwijzingweergave+(ga:GebiedsaanwijzingRef+(@type , @xlink:href) -->

						<xsl:comment>************* k:Kaart *************** </xsl:comment>

						<xsl:for-each select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//(k:Kaart)">
							<xsl:variable name="k:identificatie" select="./k:identificatie"/>
							<table class="owTable">
								<tr>
									<td>
										<div id="{$k:identificatie}" data-xml="k:Kaart" class="owObject">
											<div class="owHead">
												<span class="objectTitel" ondblclick="ShowHideOW(this)">
													<xsl:value-of select="string(./local-name())"/>
												</span>
												<span class="highLight" onClick="openCloseOWobj(this)"> ... </span>
												<span class="default" onClick="geefInkomendeRelaties(this)"> inkomende relaties </span>
												<br/>
												<span class="entry">k:naam = <span><xsl:value-of select="string(./k:naam)"/></span>
												</span>
												<br/>
											</div>
											<div class="owFields">
												<xsl:if test="./@id">
													<span class="entry">id = <xsl:value-of select="string(./@id)"/></span>
													<br/>
												</xsl:if>
												<xsl:if test="./ow:status">
													<span class="entry">ow:status = <xsl:value-of select="string(./ow:status)"/></span>
													<br/>
												</xsl:if>
												<xsl:if test="./ow:procedurestatus">
													<span class="entry">ow:procedurestatus = <xsl:value-of select="string(./ow:procedurestatus)"/></span>
													<br/>
												</xsl:if>
												<span class="entry">k:identificatie = <xsl:value-of select="string(./k:identificatie)"/></span>
												<br/>
												<span class="entry">k:naam = <xsl:value-of select="string(./k:naam)"/></span>
												<br/>
												<xsl:if test="./k:nummer">
													<span class="entry">ow:procedurestatus = <xsl:value-of select="string(./k:nummer)"/></span>
													<br/>
												</xsl:if>
												<xsl:for-each select="./k:uitsnede/k:Kaartextent/element()">
													<span class="entry">
														<xsl:value-of select="string(./local-name())"/>
														<xsl:text> = </xsl:text>
														<span>
															<xsl:value-of select="string(.)"/>
														</span>
													</span>
													<br/>
												</xsl:for-each>
												<xsl:for-each select="./k:kaartlagen/k:Kaartlaag">
													<xsl:if test="./k:naam">
														<span class="entry">/k:kaartlagen/k:Kaartlaag/k:naam = <xsl:value-of select="string(./k:naam)"/></span>
														<br/>
													</xsl:if>
													<span class="entry">/k:kaartlagen/k:Kaartlaag/k:identificatie = <xsl:value-of select="string(./k:identificatie)"/></span>
													<br/>
													<xsl:if test="./ow:status">
														<span class="entry">/k:kaartlagen/k:Kaartlaag/ow:status = <xsl:value-of select="string(./ow:status)"/></span>
														<br/>
													</xsl:if>
													<xsl:if test="./ow:procedurestatus">
														<span class="entry">/k:kaartlagen/k:Kaartlaag/ow:procedurestatus = <xsl:value-of select="string(./ow:procedurestatus)"/></span>
														<br/>
													</xsl:if>
													<span class="entry">/k:kaartlagen/k:Kaartlaag/k:niveau = <xsl:value-of select="string(./k:niveau)"/></span>
													<br/>
													<xsl:if test="./k:activiteitlocatieweergave">
														<span class="entry">/k:kaartlagen/k:Kaartlaag/k:activiteitlocatieweergave
											<xsl:text> = </xsl:text>
															<span class="link" data-target="{string(./k:activiteitlocatieweergave/@xlink:href)}" onClick="showLink('{$k:identificatie}','{(./k:activiteitlocatieweergave/@xlink:href)}')">
																<xsl:value-of select="./k:activiteitlocatieweergave/@xlink:href"/>
															</span>
														</span>
														<br/>
													</xsl:if>
													<xsl:for-each select="./k:normweergave/element()">
														<span class="entry">/k:kaartlagen/k:Kaartlaag/k:normweergave/<xsl:value-of select="string(.)"/>
															<xsl:text> = </xsl:text>
															<span class="link" data-target="{string(./@xlink:href)}" onClick="showLink('{$k:identificatie}','{(./@xlink:href)}')">
																<xsl:value-of select="./@xlink:href"/>
															</span>
														</span>
														<br/>
													</xsl:for-each>
													<xsl:for-each select="./gebiedsaanwijzingweergave/ga:GebiedsaanwijzingRef">
														<span class="entry">/k:kaartlagen/k:Kaartlaag/gebiedsaanwijzingweergave/ga:GebiedsaanwijzingRef
												<xsl:text> = </xsl:text>
															<span class="link" data-target="{string(./@xlink:href)}" onClick="showLink('{$k:identificatie}','{(./@xlink:href)}')">
																<xsl:value-of select="./@xlink:href"/>
															</span>
														</span>
														<br/>
													</xsl:for-each>
												</xsl:for-each>
											</div>
										</div>
									</td>
									<td/>
								</tr>
							</table>
						</xsl:for-each>

						<!--	rol:Omgevingsnorm -->

						<xsl:comment>************* rol:Omgevingsnorm *************** </xsl:comment>
						<xsl:for-each select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//(rol:Omgevingsnorm)">
							<xsl:variable name="rol:Omgevingsnorm" select="./rol:identificatie"/>
							<table class="owTable">
								<tr>
									<td>
										<div id="{$rol:Omgevingsnorm}" data-xml="rol:Omgevingsnorm" class="owObject">
											<div class="owHead">
												<span class="objectTitel" ondblclick="ShowHideOW(this)">
													<xsl:value-of select="string(./local-name())"/>
												</span>
												<span class="highLight" onClick="openCloseOWobj(this)"> ... </span>
												<span class="default" onClick="geefInkomendeRelaties(this)"> inkomende relaties </span>
												<br/>
												<span class="entry">rol:naam = <span><xsl:value-of select="string(./rol:naam)"/></span>
												</span>
												<br/>
											</div>
											<div class="owFields">
												<span class="entry">rol:identificatie = <xsl:value-of select="string(./rol:identificatie)"/></span>
												<br/>
												<span class="entry">rol:type = <xsl:value-of select="string(./rol:type)"/></span>
												<br/>
												<xsl:if test="./rol:eenheid">
													<span class="entry">rol:eenheid = <xsl:value-of select="string(./rol:eenheid)"/></span>
													<br/>
												</xsl:if>
												<xsl:if test="./@id">
													<span class="entry">id = <xsl:value-of select="string(./@id)"/></span>
													<br/>
												</xsl:if>
												<xsl:if test="./ow:status">
													<span class="entry">ow:status = <xsl:value-of select="string(./ow:status)"/></span>
													<br/>
												</xsl:if>
												<xsl:if test="./ow:procedurestatus">
													<span class="entry">ow:procedurestatus = <xsl:value-of select="string(./ow:procedurestatus)"/></span>
													<br/>
												</xsl:if>
												<xsl:for-each select="./rol:normwaarde/element()[not(name() eq 'rol:locatieaanduiding')]">
													<span class="entry">
														<xsl:value-of select="string(./local-name())"/>
														<xsl:text> = </xsl:text>
														<span>
															<xsl:value-of select="string(.)"/>
														</span>
													</span>
													<br/>
													<xsl:for-each select="./rol:normwaarde/rol:locatieaanduiding/element()">
														<span class="entry">
															<xsl:value-of select="string(./local-name())"/>
															<xsl:text> = </xsl:text>
															<span class="link" data-target="{string(./@xlink:href)}" onClick="showLink('{$rol:Omgevingsnorm}','{(./@xlink:href)}')">
																<xsl:value-of select="./@xlink:href"/>
															</span>
														</span>
														<br/>
													</xsl:for-each>
												</xsl:for-each>
												<span class="entry">rol:groep = <xsl:value-of select="string(./rol:groep)"/></span>
											</div>
										</div>
									</td>
									<td/>
								</tr>
							</table>
						</xsl:for-each>


						<!--	rol:Omgevingswaarde -->

						<xsl:comment>************* rol:Omgevingswaarde *************** </xsl:comment>
						<xsl:for-each select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//(rol:Omgevingswaarde)">
							<xsl:variable name="rol:Omgevingswaarde" select="./rol:identificatie"/>
							<table class="owTable">
								<tr>
									<td>
										<div id="{$rol:Omgevingswaarde}" data-xml="rol:Omgevingswaarde" class="owObject">
											<div class="owHead">
												<span class="objectTitel" ondblclick="ShowHideOW(this)">
													<xsl:value-of select="string(./local-name())"/>
												</span>
												<span class="highLight" onClick="openCloseOWobj(this)"> ... </span>
												<span class="default" onClick="geefInkomendeRelaties(this)"> inkomende relaties </span>
												<br/>
												<span class="entry">rol:naam = <span><xsl:value-of select="string(./rol:naam)"/></span>
												</span>
												<br/>
											</div>
											<div class="owFields">
												<span class="entry">rol:identificatie = <xsl:value-of select="string(./rol:identificatie)"/></span>
												<br/>
												<span class="entry">rol:type = <xsl:value-of select="string(./rol:type)"/></span>
												<br/>
												<xsl:if test="./rol:eenheid">
													<span class="entry">rol:eenheid = <xsl:value-of select="string(./rol:eenheid)"/></span>
													<br/>
												</xsl:if>
												<xsl:if test="./@id">
													<span class="entry">id = <xsl:value-of select="string(./@id)"/></span>
													<br/>
												</xsl:if>
												<xsl:if test="./ow:status">
													<span class="entry">ow:status = <xsl:value-of select="string(./ow:status)"/></span>
													<br/>
												</xsl:if>
												<xsl:if test="./ow:procedurestatus">
													<span class="entry">ow:procedurestatus = <xsl:value-of select="string(./ow:procedurestatus)"/></span>
													<br/>
												</xsl:if>
												<xsl:for-each select="./rol:normwaarde/element()[not(name() eq 'rol:locatieaanduiding')]">
													<span class="entry">
														<xsl:value-of select="string(./local-name())"/>
														<xsl:text> = </xsl:text>
														<span>
															<xsl:value-of select="string(.)"/>
														</span>
													</span>
													<br/>
													<xsl:for-each select="./rol:normwaarde/rol:locatieaanduiding/element()">
														<span class="entry">
															<xsl:value-of select="string(./local-name())"/>
															<xsl:text> = </xsl:text>
															<span class="link" data-target="{string(./@xlink:href)}" onClick="showLink('{$rol:Omgevingswaarde}','{(./@xlink:href)}')">
																<xsl:value-of select="./@xlink:href"/>
															</span>
														</span>
														<br/>
													</xsl:for-each>
												</xsl:for-each>
												<span class="entry">rol:groep = <xsl:value-of select="string(./rol:groep)"/></span>
											</div>
										</div>
									</td>
									<td/>
								</tr>
							</table>
						</xsl:for-each>



						<!--	p:pons	-->

						<xsl:comment>************* p:Pons *************** </xsl:comment>
						<xsl:for-each select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//(p:Pons)">
							<xsl:variable name="p:identificatie" select="./p:identificatie"/>
							<table class="owTable">
								<tr>
									<td>
										<div id="{$p:identificatie}" data-xml="p:Pons" class="owObject">
											<div class="owHead">
												<span class="objectTitel" ondblclick="ShowHideOW(this)">
													<xsl:value-of select="string(./local-name())"/>
												</span>
												<span class="highLight" onClick="openCloseOWobj(this)"> ... </span>
												<span class="default" onClick="geefInkomendeRelaties(this)"> inkomende relaties </span>
												<br/>
												<span class="entry">p:identificatie = <xsl:value-of select="string(./p:identificatie)"/></span>
												<br/>
											</div>
											<div class="owFields">
												<xsl:for-each select="./p:locatieaanduiding/element()">
													<span class="entry">
														<xsl:value-of select="string(./local-name())"/>
														<xsl:text> = </xsl:text>
														<span class="link" data-target="{string(./@xlink:href)}" onClick="showLink('{$p:identificatie}','{(./@xlink:href)}')">
															<xsl:value-of select="./@xlink:href"/>
														</span>
													</span>
													<br/>
												</xsl:for-each>
												<xsl:if test="./ow:status">
													<span class="entry">ow:status = <xsl:value-of select="string(./ow:status)"/></span>
													<br/>
												</xsl:if>
												<xsl:if test="./ow:procedurestatus">
													<span class="entry">ow:procedurestatus = <xsl:value-of select="string(./ow:procedurestatus)"/></span>
													<br/>
												</xsl:if>
											</div>
										</div>
									</td>
									<td/>
								</tr>
							</table>
						</xsl:for-each>



						<!--	rg:Regelingsgebied -->

						<xsl:comment>************* rg:Regelingsgebied *************** </xsl:comment>
						<xsl:for-each select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//(rg:Regelingsgebied)">
							<xsl:variable name="rg:identificatie" select="./rg:identificatie"/>
							<table class="owTable">
								<tr>
									<td>
										<div id="{$rg:identificatie}" data-xml="rg:Regelingsgebied" class="owObject">
											<div class="owHead">
												<span class="objectTitel" ondblclick="ShowHideOW(this)">
													<xsl:value-of select="string(./local-name())"/>
												</span>
												<span class="highLight" onClick="openCloseOWobj(this)"> ... </span>
												<span class="default" onClick="geefInkomendeRelaties(this)"> inkomende relaties </span>
												<br/>
												<span class="entry">rg:identificatie = <span><xsl:value-of select="string($rg:identificatie)"/></span>
												</span>
												<br/>
											</div>
											<div class="owFields">
												<xsl:if test="./ow:status">
													<span class="entry">ow:status = <xsl:value-of select="string(./ow:status)"/></span>
													<br/>
												</xsl:if>
												<xsl:if test="./ow:procedurestatus">
													<span class="entry">ow:procedurestatus = <xsl:value-of select="string(./ow:procedurestatus)"/></span>
													<br/>
												</xsl:if>
												<xsl:for-each select="./rg:locatieaanduiding/element()">
													<span class="entry">
														<xsl:value-of select="string(./local-name())"/>
														<xsl:text> = </xsl:text>
														<span class="link" data-target="{string(./@xlink:href)}" onClick="showLink('{$rg:identificatie}','{(./@xlink:href)}')">
															<xsl:value-of select="./@xlink:href"/>
														</span>
													</span>
													<br/>
												</xsl:for-each>
											</div>
										</div>
									</td>
									<td/>
								</tr>
							</table>
						</xsl:for-each>





						<!-- GML -->

						<!-- LET OP GML id is 'GML-' plus ID; belangrijk voor pointers ernaar-->

						<xsl:comment>************* GML *************** </xsl:comment>

						<xsl:for-each select="collection(concat('', $opdracht.dir, '?select=*.gml;recurse=yes'))">
							<!-- conflict met id vd GIO, is hetzelfde, dus bestandsnaam -->
							<table class="owTable">
								<tr>
									<td>
										<div id="{concat('GML-', .//geo:FRBRExpression[1])}" class="owObject" data-xml="GML">
											<span class="objectTitel" ondblclick="ShowHideOW(this)">GML </span>
											<span class="default">(geo:GeoInformatieObjectVaststelling)</span>
											<span class="default" onClick="geefInkomendeRelaties(this)"> inkomende relaties </span>
											<br/>
											<xsl:text>geo:FRBRExpression = </xsl:text>
											<xsl:value-of select=".//geo:FRBRExpression[1]"/>
											<br/>
											<span data-target="{string(.//geo:FRBRExpression[1])}" onClick="showLink('2','{.//geo:FRBRExpression[1]}')">GIO = 
												<span class="link"> <xsl:value-of select=".//geo:FRBRExpression[1]"/></span></span>
											<br/>
											<span class="entry">
												<xsl:text>gio:achtergrondVerwijzing = </xsl:text>
											</span>
											<xsl:value-of select=".//gio:achtergrondVerwijzing[1]"/>
											<br/>
											<span class="entry">
												<xsl:text>gio:achtergrondActualiteit = </xsl:text>
											</span>
											<br/>
											<xsl:value-of select=".//gio:achtergrondActualiteit[1]"/>
											<br/>
											<xsl:for-each select="//geo:Locatie">
												<span class="entry">
													<xsl:text>locatie naam = </xsl:text>
												</span>
												<br/>
												<xsl:value-of select="./geo:naam"/>
												<br/>
												<xsl:for-each select=".//basisgeo:id">
													<span class="entry" id="{string(.)}" data-xml="basisgeo:id">
														<xsl:text>basisgeo:id (GUID) = </xsl:text>
														<xsl:value-of select="string(.)"/>
													</span>
													<br/>
												</xsl:for-each>
											</xsl:for-each>
											<br/>
										</div>
									</td>
									<td/>
								</tr>
							</table>

						</xsl:for-each>






						<!-- /div met  class="divOW"-->


					</div>


					<!--******************************OP-OBJECTEN*************************-->

					<xsl:comment>************* OP-OBJECTEN *************** </xsl:comment>


					<div class="divOP" id="2">
						<h2>AanleveringsBesluit</h2>
						<xsl:apply-templates select="$besluit//(BesluitCompact | BesluitKlassiek)//(RegelingCompact | RegelingKlassiek | RegelingTijdelijkdeel | RegelingVrijetekst | RegelingMutatie)"
							xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
						<div class="regeltekst">
							<iframe src="regeling.html" name="regeling">
								<p>Jouw browser ondersteunt geen iframes. Gebruik s.v.p. de Firefox browser</p>
							</iframe>
						</div>



						<!--**************GIO's *************-->

						<xsl:comment>************* GIO's *************** </xsl:comment>

						<xsl:for-each select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//InformatieObjectVersie" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
							<div id="{(././/data:FRBRExpression[1])}" data-xml="GIO" class="divLinks0">
								<!--class="owObject"-->
								<span class="objectTitel" ondblclick="ShowHideOW(this)">Geografisch Informatieobject (GIO) <xsl:value-of select="string(./local-name())"/>
								</span>
								<br/>
								<span class="entry">data:naamInformatieObject = <xsl:value-of select="string(.//data:naamInformatieObject[1])"/></span>
								<br/>
								<span class="entry"><xsl:value-of select="name(//data:officieleTitel[1])"/> = </span>
								<xsl:value-of select="string(//data:officieleTitel[1])"/>
								<br/>
								<span class="entry"><xsl:value-of select="name(//data:bestandsnaam[1])"/> = </span>
								<xsl:value-of select="string(//data:bestandsnaam[1])"/>
								<br/>
								<span class="entry">GML = 
									<span class="link" onClick="showLink('1','{concat('GML-', (././/data:FRBRExpression[1]))}')"><xsl:value-of select="(././/data:FRBRExpression[1])"/></span></span>
								<br/>
								<xsl:for-each select=".//data:alternatieveTitel">
									<span class="entry"><xsl:value-of select="name(.)"/> = </span>
									<xsl:value-of select="string(.)"/>
									<br/>
								</xsl:for-each>
							</div>
						</xsl:for-each>
					</div>
				</div>
				<!-- /divmain-->
			</body>
		</html>
	</xsl:template>




	<xsl:template match="RegelingCompact | RegelingKlassiek | RegelingTijdelijkdeel | RegelingVrijetekst | RegelingMutatie" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<h3 id="frags" onclick="fetch(['Artikel'])">Regelingfragmenten met OW relaties</h3>

		<xsl:if test=".//Artikel" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
			<xsl:for-each select=".//(Artikel[not(Lid) and (descendant::ExtIoRef or descendant::IntIoRef)] | Lid[descendant::ExtIoRef or descendant::IntIoRef])"
				xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">

				<xsl:choose>
					<xsl:when test="self::Artikel">
						<div class="divLinks0" data-xml="Artikel" id="{@wId}">
							<span onclick="ShowHide(this)">
								<span class="fs70">(artikelverwijzing) </span>
								<xsl:value-of select="fn:string-join((Kop/(Label, Nummer)), ' ')"/>
							</span>
							<br/>
							<!--<xsl:for-each select="IntIoRef"></xsl:for-each>-->
							<p class="regel">
								<xsl:apply-templates/>
							</p>
						</div>
					</xsl:when>
					<xsl:when test="self::Lid">
						<div class="divLinks0" data-xml="Lid" id="{@wId}">
							<span onclick="ShowHide(this)">
								<span class="fs70">(lidverwijzing) </span>
								<xsl:value-of select="fn:string-join((fn:string-join((ancestor-or-self::Artikel/Kop/(Label, Nummer)), ' '), fn:string-join(('Lid', LidNummer), ' ')), ', ')"/>
							</span>
							<br/>
							<p class="regel">
								<xsl:apply-templates/>
							</p>
						</div>

					</xsl:when>

					<!--					
					<xsl:if test=".//Divisie" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
						<div class="content">
							<table>
								<colgroup>
									<col width="165px"/>
									<col width="auto"/>
								</colgroup>
								<thead onclick="ShowHide(this)">
									<tr>
										<th colspan="2"><p class="titel">Divisie</p></th>
									</tr>
								</thead>
								<tbody>
									<xsl:call-template name="divisie">
										<xsl:with-param name="node-list" select=".//(Bijlage|Toelichting|AlgemeneToelichting|ArtikelgewijzeToelichting|Lichaam/(Divisie|InleidendeTekst|Divisietekst))[string(Kop) ne '']"/>
									</xsl:call-template>
								</tbody>
							</table>
						</div>
					</xsl:if>
-->

				</xsl:choose>


			</xsl:for-each>

		</xsl:if>



	</xsl:template>


	<xsl:template match="IntIoRef" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<span class="tooltip">
			<span class="tooltiptext">link naar het informatieobject in de regeling</span>
			<a style="color:#FF0000" target="regeling" href="{concat('regeling.html#', ./@wId)}" id="{./@wId}" data-xml="IntIoRef">
				<xsl:value-of select="string(./text())"/>
			</a>
		</span>
	</xsl:template>

	<xsl:template name="divisie">
		<xsl:param name="node-list"/>
		<xsl:for-each select="$node-list" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
			<xsl:variable name="wId" select="@wId"/>
			<xsl:variable name="ref" select=".//IntIoRef[ancestor::element()[Divisie | InleidendeTekst | Divisietekst][1][@wId = $wId]]/@ref"/>
			<xsl:variable name="divisie" select="$divisies[@wId = $wId]"/>
			<xsl:variable name="tekstdeel" select="$tekstdelen[vt:divisieaanduiding/vt:DivisieRef/@xlink:href = $divisie/vt:identificatie]"/>
			<tr>
				<td>
					<p class="naam">
						<xsl:value-of select="fn:string-join((Kop/(Label, Nummer, Opschrift)), ' ')"/>
					</p>
				</td>
				<td>
					<xsl:call-template name="waarde">
						<xsl:with-param name="current">
							<xsl:element name="wId">
								<xsl:value-of select="@wId"/>
							</xsl:element>
							<xsl:element name="kruimelpad">
								<xsl:value-of select="fn:string-join(ancestor-or-self::element()[Divisie | InleidendeTekst | Divisietekst][string(Kop) ne '']/Kop/Opschrift, '|')"
									xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
							</xsl:element>
							<xsl:for-each select="root()//ExtIoRef[@wId = $ref]">
								<xsl:element name="BeoogdInformatieobject">
									<xsl:value-of select="."/>
								</xsl:element>
							</xsl:for-each>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="object">
						<xsl:with-param name="current" select="$tekstdeel"/>
					</xsl:call-template>
				</td>
			</tr>
			<xsl:call-template name="divisie">
				<xsl:with-param name="node-list" select="./(Divisie | InleidendeTekst | Divisietekst)[string(Kop) ne '']"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="waarde">
		<xsl:param name="current"/>
		<xsl:choose>
			<xsl:when test="$current/self::element() | $current/self::attribute() | $current/element()">
				<xsl:attribute name="style" select="string('padding: 0pt;')"/>
				<table>
					<colgroup>
						<col width="175px"/>
						<col width="auto"/>
					</colgroup>
					<tbody>
						<xsl:for-each select="$current/descendant-or-self::element()[text() | attribute()] | $current/self::attribute()">
							<tr>
								<td>
									<p class="naam">
										<xsl:value-of select="./name()"/>
									</p>
								</td>
								<td>
									<xsl:choose>
										<xsl:when test="./@xlink:href">
											<p class="waarde">
												<xsl:value-of select="./@xlink:href"/>
											</p>
										</xsl:when>
										<xsl:when test="self::element()">
											<xsl:call-template name="waarde">
												<xsl:with-param name="current" select="text(), element(), attribute()"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="self::attribute()">
											<p class="waarde">
												<xsl:value-of select="."/>
											</p>
										</xsl:when>
									</xsl:choose>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:when>
			<xsl:when test="$current/self::text()">
				<xsl:variable name="waarde" select="."/>
				<xsl:variable name="label" select="$waardelijsten//Waarde[id = $waarde]/label"/>
				<xsl:choose>
					<xsl:when test="$label">
						<p class="waarde">
							<xsl:value-of select="concat($waarde, ' ')"/>
							<span class="label">
								<xsl:value-of select="concat('(', fn:string-join(fn:distinct-values($label), ', '), ')')"/>
							</span>
						</p>
					</xsl:when>
					<xsl:otherwise>
						<p class="waarde">
							<xsl:value-of select="$waarde"/>
						</p>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>



	<!--isoleren-->
	<xsl:template name="object">
		<xsl:param name="current"/>
		<xsl:for-each select="$current/self::element()">
			<table>
				<colgroup>
					<col width="175px"/>
					<col width="auto"/>
				</colgroup>
				<thead onclick="ShowHide(this)">
					<tr>
						<th colspan="2">
							<p class="titel">
								<xsl:value-of select="./local-name()"/>
							</p>
						</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="(./element() | attribute())">
						<tr>
							<td>
								<p class="naam">
									<xsl:value-of select="./local-name()"/>
								</p>
							</td>
							<td>
								<xsl:choose>
									<!-- wim 'verwijzers' -->
									<xsl:when test="./self::r:artikelOfLid | ./self::vt:divisieaanduiding | ./self::rol:bovenliggendeActiviteit | ./self::k:gebiedsaanwijzingweergave">
										<xsl:for-each select="./element()/@xlink:href">
											<p class="waarde">
												<xsl:value-of select="."/>
											</p>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="./self::l:geometrie">
										<xsl:attribute name="style" select="string('padding: 0pt;')"/>
										<xsl:for-each select="./l:GeometrieRef/@xlink:href">
											<xsl:variable name="id" select="string(.)"/>
											<xsl:call-template name="object">
												<xsl:with-param name="current" select="$gml/Locatie[contains(@geo-id, $id)]"/>
											</xsl:call-template>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="./self::r:locatieaanduiding | ./self::rol:locatieaanduiding | ./self::ga:locatieaanduiding | ./self::vt:locatieaanduiding">
										<xsl:attribute name="style" select="string('padding: 0pt;')"/>
										<xsl:variable name="id" select="./l:LocatieRef/@xlink:href"/>
										<xsl:for-each select="$locaties[l:identificatie = $id]">
											<xsl:call-template name="object">
												<xsl:with-param name="current" select="."/>
											</xsl:call-template>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="./self::l:groepselement">
										<xsl:attribute name="style" select="string('padding: 0pt;')"/>
										<xsl:variable name="id" select="./l:GebiedRef/@xlink:href"/>
										<xsl:for-each select="$locaties[l:identificatie = $id]">
											<xsl:call-template name="object">
												<xsl:with-param name="current" select="."/>
											</xsl:call-template>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="./self::r:activiteitaanduiding">
										<xsl:attribute name="style" select="string('padding: 0pt;')"/>
										<xsl:variable name="id" select="./rol:ActiviteitRef/@xlink:href"/>
										<xsl:for-each select="$activiteiten[rol:identificatie = $id]">
											<xsl:call-template name="object">
												<xsl:with-param name="current" select="."/>
											</xsl:call-template>
										</xsl:for-each>
										<xsl:for-each select="./r:ActiviteitLocatieaanduiding">
											<xsl:call-template name="object">
												<xsl:with-param name="current" select="."/>
											</xsl:call-template>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="./self::r:gebiedsaanwijzing | ./self::vt:gebiedsaanwijzing">
										<xsl:attribute name="style" select="string('padding: 0pt;')"/>
										<xsl:variable name="id" select="./ga:GebiedsaanwijzingRef/@xlink:href"/>
										<xsl:for-each select="$gebiedsaanwijzingen[ga:identificatie = $id]">
											<xsl:call-template name="object">
												<xsl:with-param name="current" select="."/>
											</xsl:call-template>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="./self::r:omgevingsnormaanduiding">
										<xsl:attribute name="style" select="string('padding: 0pt;')"/>
										<xsl:variable name="id" select="./rol:OmgevingsnormRef/@xlink:href"/>
										<xsl:for-each select="$omgevingsnormaanduidingen[rol:identificatie = $id]">
											<xsl:call-template name="object">
												<xsl:with-param name="current" select="."/>
											</xsl:call-template>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="./self::r:omgevingswaardeaanduiding">
										<xsl:attribute name="style" select="string('padding: 0pt;')"/>
										<xsl:variable name="id" select="./rol:OmgevingswaardeRef/@xlink:href"/>
										<xsl:for-each select="$omgevingswaardeaanduidingen[rol:identificatie = $id]">
											<xsl:call-template name="object">
												<xsl:with-param name="current" select="."/>
											</xsl:call-template>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="./self::rol:normwaarde">
										<xsl:attribute name="style" select="string('padding: 0pt;')"/>
										<xsl:for-each select="./rol:Normwaarde">
											<xsl:call-template name="object">
												<xsl:with-param name="current" select="."/>
											</xsl:call-template>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="./self::vt:hoofdlijnaanduiding">
										<xsl:attribute name="style" select="string('padding: 0pt;')"/>
										<xsl:variable name="id" select="./vt:HoofdlijnRef/@xlink:href"/>
										<xsl:for-each select="$hoofdlijnaanduidingen[vt:identificatie = $id]">
											<xsl:call-template name="object">
												<xsl:with-param name="current" select="."/>
											</xsl:call-template>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="./self::vt:kaartaanduiding">
										<xsl:attribute name="style" select="string('padding: 0pt;')"/>
										<xsl:variable name="id" select="./k:KaartRef/@xlink:href"/>
										<xsl:for-each select="$kaarten[k:identificatie = $id]">
											<xsl:call-template name="object">
												<xsl:with-param name="current" select="."/>
											</xsl:call-template>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="./self::k:uitsnede">
										<xsl:attribute name="style" select="string('padding: 0pt;')"/>
										<xsl:for-each select="./k:Kaartextent">
											<xsl:call-template name="object">
												<xsl:with-param name="current" select="."/>
											</xsl:call-template>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="./self::k:kaartlagen">
										<xsl:attribute name="style" select="string('padding: 0pt;')"/>
										<xsl:for-each select="./k:Kaartlaag">
											<xsl:call-template name="object">
												<xsl:with-param name="current" select="."/>
											</xsl:call-template>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<p class="waarde">
											<xsl:value-of select="string(.)"/>
										</p>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="ExpressionIdentificatie" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
		<div class="content">
			<table>
				<colgroup>
					<col width="175px"/>
					<col width="auto"/>
				</colgroup>
				<thead onclick="ShowHide(this)">
					<tr>
						<th colspan="2">
							<p class="titel">
								<xsl:value-of select="./name()"/>
							</p>
						</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="element()">
						<tr>
							<td>
								<p class="naam">
									<xsl:value-of select="./name()"/>
								</p>
							</td>
							<td>
								<xsl:call-template name="waarde">
									<xsl:with-param name="current" select="text(), element()"/>
								</xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</div>
	</xsl:template>

	<xsl:template match="BesluitMetadata" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
		<!--  	<xsl:message>XXXXXXXXXXXXXXXXXXXXX <xsl:value-of select="."/></xsl:message>-->
		<div class="content">
			<table>
				<colgroup>
					<col width="175px"/>
					<col width="auto"/>
				</colgroup>
				<thead onclick="ShowHide(this)">
					<tr>
						<th colspan="2">
							<p class="titel">
								<xsl:value-of select="./name()"/>
							</p>
						</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each
						select="eindverantwoordelijke, maker, officieleTitel, heeftCiteertitelInformatie//citeertitel, onderwerpen/onderwerp, rechtsgebieden/rechtsgebied, soortProcedure, informatieobjectRefs/informatieobjectRef"
						xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
						<tr>
							<td>
								<p class="naam">
									<xsl:value-of select="./name()"/>
								</p>
							</td>
							<td>
								<xsl:call-template name="waarde">
									<xsl:with-param name="current" select="text(), element()"/>
								</xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</div>
	</xsl:template>

	<xsl:template match="Procedureverloop" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
		<div class="content">
			<table>
				<colgroup>
					<col width="175px"/>
					<col width="auto"/>
				</colgroup>
				<thead onclick="ShowHide(this)">
					<tr>
						<th colspan="2">
							<p class="titel">
								<xsl:value-of select="./name()"/>
							</p>
						</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="bekendOp, ontvangenOp, procedurestappen/Procedurestap" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
						<tr>
							<td>
								<p class="naam">
									<xsl:value-of select="./name()"/>
								</p>
							</td>
							<td>
								<xsl:call-template name="waarde">
									<xsl:with-param name="current" select="text(), element()"/>
								</xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</div>
	</xsl:template>

	<xsl:template match="ConsolidatieInformatie/BeoogdeRegelgeving" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
		<div class="content">
			<table>
				<colgroup>
					<col width="175px"/>
					<col width="auto"/>
				</colgroup>
				<thead onclick="ShowHide(this)">
					<tr>
						<th colspan="2">
							<p class="titel">
								<xsl:value-of select="./name()"/>
							</p>
						</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="element()" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
						<tr>
							<td>
								<p class="naam">
									<xsl:value-of select="./name()"/>
								</p>
							</td>
							<td>
								<xsl:call-template name="waarde">
									<xsl:with-param name="current" select="text(), element()"/>
								</xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</div>
	</xsl:template>

	<xsl:template match="ConsolidatieInformatie/Tijdstempels" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
		<div class="content">
			<table>
				<colgroup>
					<col width="175px"/>
					<col width="auto"/>
				</colgroup>
				<thead onclick="ShowHide(this)">
					<tr>
						<th colspan="2">
							<p class="titel">
								<xsl:value-of select="./name()"/>
							</p>
						</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="element()" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
						<tr>
							<td>
								<p class="naam">
									<xsl:value-of select="./name()"/>
								</p>
							</td>
							<td>
								<xsl:call-template name="waarde">
									<xsl:with-param name="current" select="text(), element()"/>
								</xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</div>
	</xsl:template>

	<!--uit regeling.xsl-->

	<!--<xsl:template match="Lichaam|Inhoud" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<xsl:apply-templates select="./node()"/>
	</xsl:template>
	
	<xsl:template match="Afdeling|Artikel|Boek|Deel|Hoofdstuk|Paragraaf|Subparagraaf|Subsubparagraaf|Titel" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<xsl:choose>
			<xsl:when test="fn:string-join(Kop/element(),'') ne ''">
				<section class="{lower-case(name())}">
					<xsl:apply-templates select="./node()"/>
				</section>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="./node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="AlgemeneToelichting|ArtikelgewijzeToelichting|Bijlage|Divisie|Divisietekst|InleidendeTekst|Toelichting" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<xsl:choose>
			<xsl:when test="fn:string-join(Kop/element(),'') ne ''">
				<section class="divisie">
					<xsl:apply-templates select="./node()"/>
				</section>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="./node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="Lid" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<section class="lid">
			<div class="lidnummer">
				<xsl:apply-templates select="./LidNummer"/>
			</div>
			<xsl:apply-templates select="./Inhoud"/>
		</section>
	</xsl:template>
	
	<!-\- block -\->
	
	<xsl:template match="RegelingOpschrift" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<p class="titel"><xsl:apply-templates select="./Al/node()"/></p>
	</xsl:template>
	
	<xsl:template match="Kop" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<xsl:choose>
			<xsl:when test="fn:string-join(./element(),'') ne ''">
				<xsl:variable name="id" select="generate-id(.)"/>
				<xsl:variable name="level" select="count(ancestor::ArtikelgewijzeToelichting|ancestor::AlgemeneToelichting|ancestor::Bijlage|ancestor::Divisie|ancestor::Divisietekst|ancestor::InleidendeTekst|ancestor::Toelichting)"/>
				<p class="{if ($level gt 0) then fn:string-join(('kop',$level),'_') else string('kop')}" id="{$id}"><span class="nummer"><xsl:value-of select="fn:string-join((./Label,./Nummer),' ')"/></span><xsl:apply-templates select="./Opschrift/node()"/></p>
			</xsl:when>
			<xsl:otherwise>
				<!-\- doe niets -\->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	
	
	
	<xsl:template match="Al" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<p class="standaard"><xsl:apply-templates select="./node()"/></p>
	</xsl:template>
	
	<xsl:template match="Gereserveerd" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<p class="standaard"><xsl:value-of select="string('[Gereserveerd]')"/></p>
	</xsl:template>
	
	<xsl:template match="Tussenkop" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<p class="tussenkop"><xsl:apply-templates select="./node()"/></p>
	</xsl:template>
	
	<xsl:template match="LidNummer" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<p class="lidnummer"><xsl:apply-templates select="./node()"/></p>
	</xsl:template>
	
	<!-\- inline -\->
	
	<xsl:template match="b" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<span class="vet"><xsl:apply-templates/></span>
	</xsl:template>
	
	<xsl:template match="i" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<span class="cursief"><xsl:apply-templates/></span>
	</xsl:template>
	
	<xsl:template match="u" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<span class="onderstreept"><xsl:apply-templates/></span>
	</xsl:template>
	
	<xsl:template match="sup" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<span class="superscript"><xsl:apply-templates/></span>
	</xsl:template>
	
	<xsl:template match="sub" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<span class="subscript"><xsl:apply-templates/></span>
	</xsl:template>
	
	<xsl:template match="ExtRef" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<a href="{@doc}" target="_blank">
			<xsl:apply-templates/>
		</a>
	</xsl:template>
	
	<xsl:template match="br" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<br/>
	</xsl:template>
	
	<!-\- opsomming -\->
	
	<xsl:template match="Lijst" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<div class="nummering">
			<xsl:apply-templates select="*"/>
		</div>
	</xsl:template>
	<!-\-wim debug xsl:value-of select="./node()" vervangen door xsl:apply-templates -\->
	<xsl:template match="Lijstaanhef" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<p class="standaard"><xsl:apply-templates/></p>
	</xsl:template>
	
	<xsl:template match="Li" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<div class="item">
			<xsl:apply-templates select="element()"/>
		</div>
	</xsl:template>
	
	<xsl:template match="LiNummer" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<div class="nummer"><p class="standaard"><xsl:value-of select="."/></p></div>
	</xsl:template>
	
	<!-\- begrippenlijst -\->
	
	<xsl:template match="Begrippenlijst" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<div class="begrippenlijst">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="Begrip" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<div class="begrip">
			<xsl:apply-templates select="Term"/>
			<xsl:apply-templates select="Definitie"/>
		</div>
	</xsl:template>
	
	<xsl:template match="Term" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<p class="term"><xsl:apply-templates select="./node()"/></p>
	</xsl:template>
	
	<xsl:template match="Definitie" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<xsl:apply-templates select="./node()"/>
	</xsl:template>
	
	<!-\- tabel -\->
	
	<xsl:template match="table" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<table class="standaard">
			<xsl:apply-templates select="*"/>
		</table>
	</xsl:template>
	
	<xsl:template match="table/title" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<caption class="standaard">
			<xsl:apply-templates select="./node()"/>
		</caption>
	</xsl:template>
	
	<xsl:template match="tgroup" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<xsl:variable name="col">
			<xsl:for-each select="./colspec" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
				<xsl:element name="width">
					<xsl:value-of select="fn:tokenize(./@colwidth,'\*')[1]"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:variable>
		<colgroup>
			<xsl:for-each select="$col/width" xpath-default-namespace="">
				<col style="{concat('width: ',. div sum($col/width) * 100,'%')}"/>
			</xsl:for-each>
		</colgroup>
		<xsl:apply-templates select="./thead"/>
		<xsl:apply-templates select="./tbody"/>
	</xsl:template>
	
	<xsl:template match="thead" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<thead class="standaard">
			<xsl:apply-templates select="*"/>
		</thead>
	</xsl:template>
	
	<xsl:template match="tbody" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<tbody class="standaard">
			<xsl:apply-templates select="*"/>
		</tbody>
	</xsl:template>
	
	<xsl:template match="row" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<tr class="standaard">
			<xsl:apply-templates select="*"/>
		</tr>
	</xsl:template>
	
	<xsl:template match="entry" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<xsl:variable name="colspan" select="number(substring(./@nameend,4))-number(substring(./@namest,4))+1"/>
		<xsl:variable name="rowspan" select="number(./(@morerows,'0')[1])+1"/>
		<xsl:choose>
			<xsl:when test="ancestor::thead" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
				<th class="standaard" colspan="{$colspan}" rowspan="{$rowspan}" style="{concat('text-align:',./@align)}">
					<xsl:apply-templates select="*"/>
				</th>
			</xsl:when>
			<xsl:when test="ancestor::tbody" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
				<td class="standaard" colspan="{$colspan}" rowspan="{$rowspan}" style="{concat('text-align:',./@align)}">
					<xsl:apply-templates select="*"/>
				</td>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-\- figuur -\->
	
	<xsl:template match="Figuur" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<xsl:variable name="width">
			<!-\- voor het geval er meer illustraties in een kader mogen, wordt de breedte berekend met sum -\->
			<xsl:variable name="sum" select="fn:sum(Illustratie/number(@breedte))"/>
			<xsl:choose>
				<xsl:when test="$sum lt 75">
					<xsl:value-of select="$sum"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="100"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="float">
			<xsl:choose>
				<xsl:when test="(./@tekstomloop='ja')">
					<xsl:choose>
						<xsl:when test="./@uitlijning=('links','rechts')">
							<xsl:value-of select="string(./@uitlijning)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('geen')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="string('geen')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div class="{fn:string-join(('figuur',$float),' ')}" style="{concat('width: ',$width,'%')}">
			<xsl:apply-templates select="*"/>
		</div>
	</xsl:template>
	
	<xsl:template match="Figuur/Illustratie" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<img class="figuur" src="{concat('media/',./@naam)}" width="{concat(my:value-to-pt(./@breedte),'px')}" alt="{./@alt}"/>
	</xsl:template>
	
	<xsl:template match="Figuur/Bijschrift" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<p class="bijschrift"><xsl:apply-templates select="./node()"/></p>
	</xsl:template>
	
	<!-\- voetnoot -\->
	
	<xsl:template match="Noot" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
		<a class="noot"><xsl:value-of select="concat('[',NootNummer,']')"/><span class="noottekst"><xsl:apply-templates select="Al/node()"/><xsl:text> </xsl:text></span></a>
	</xsl:template>
	
	<!-\- functies -\->
	
	<xsl:function name="my:value-to-mm" as="xs:decimal">
		<xsl:param name="value"/>
		<xsl:variable name="units" select="('twip','cm','in','mm','pt','px')"/>
		<xsl:variable name="twips" select="(0.0176388889,10,25.4,1,0.3527777778,0.2645833333)"/>
		<xsl:variable name="unit" select="($units[contains($value,.)],$units[1])[1]"/>
		<xsl:value-of select="number(fn:tokenize($value,$unit)[1]) * $twips[fn:index-of($units,$unit)]"/>
	</xsl:function>
	
	<xsl:function name="my:value-to-pt" as="xs:decimal">
		<xsl:param name="value"/>
		<xsl:variable name="units" select="('twip','cm','in','mm','pt','px')"/>
		<xsl:variable name="twips" select="(0.05,28.346456693,72,2.834645669,1,0.752929)"/>
		<xsl:variable name="unit" select="($units[contains($value,.)],$units[1])[1]"/>
		<xsl:value-of select="number(fn:tokenize($value,$unit)[1]) * $twips[fn:index-of($units,$unit)]"/>
	</xsl:function>
	
	-->



</xsl:stylesheet>
