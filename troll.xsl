<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://my.netscape.com/rdf/simple/0.9/" xmlns:rss="http://purl.org/rss/1.0/" xmlns:troll="http://random.pwnz.org" exclude-result-prefixes="troll">
	<!-- also see  https://www.saxonica.com/saxon-js/index.xml -->
	<!-- or do saxon -xsl:troll.xsl -s:troll.xml -o:troll.html -->
	<xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes" />
	<xsl:variable name="title" select="'101010 - my news site'"/>
	<xsl:variable name="path" select="'assets'"/> <!-- path to assets -->
	<xsl:variable name="home" select="'𝓗'"/> <!-- ⌂ ℍ 𝔽 📰 🗟 𝓗 𝓕 -->
	<xsl:variable name="feed" select="'𝓕'"/>
	<xsl:variable name="color" select="troll:fallback(//config/@color,'blue.css')"/>
	<xsl:variable name="style" select="troll:fallback(//config/@style,'101010.css')"/>
	<xsl:variable name="count" select="troll:fallback(//config/@max,20)"/>
	<xsl:variable name="tax" select="500"/><!-- abbreviate titles -->

	<xsl:template match="/">
		<html>
			<head>
				<title><xsl:value-of select="$title"/> - <xsl:value-of select="format-time(current-time(), '[H01]:[m01]:[s01]')"/></title>
				<link href="{$path}/{$color}" rel="stylesheet" type="text/css"/>
				<link href="{$path}/{$style}" rel="stylesheet" type="text/css"/>
				<link href="{$path}/troll.png" rel="icon"/>
			</head>
			<body>
				<header>
					<time><xsl:value-of select="format-time(current-time(), '[H01]:[m01]:[s01]')"/></time>
					<h1>&#160;<xsl:value-of select="$title"/></h1>
				</header>
				<main>
					<xsl:apply-templates/>
				</main>
				<footer>
					about | config | help
				</footer>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="feed">
		<section>
			<xsl:variable name="title" select="document(.)/atom:feed/atom:title|document(.)//channel/title|document(.)//rdf:channel/rdf:title|document(.)//rss:channel/rss:title"/>
			<xsl:variable name="copy"  select="document(.)/atom:feed/atom:rights|document(.)//copyright|document(.)//rdf:copyright|document(.)//rss:copyright|document(.)//dc:rights"/>
			<xsl:variable name="desc"  select="document(.)/atom:feed/atom:subtitle|document(.)//channel/description|document(.)//rdf:channel/rdf:description|document(.)//rss:channel/rss:description"/>
			<xsl:variable name="link"  select="document(.)/atom:feed/atom:link[not(@rel='self')][not(@rel='hub')]/@href|document(.)//channel/link|document(.)//rdf:channel/rdf:link|document(.)//rss:channel/rss:link"/>
			<header>
				<h2>
					<xsl:attribute name="title" select="$desc"/>
					<xsl:text> </xsl:text><xsl:value-of select="$title"/><xsl:text> </xsl:text>
					<a><xsl:attribute name="href" select="$link"/><xsl:value-of select="$home"/></a>
					<a><xsl:attribute name="href" select="."/><xsl:value-of select="$feed"/></a>
				</h2>
			</header>
			<xsl:apply-templates select="document(.)//atom:entry|document(.)//item|document(.)//rdf:item|document(.)//rss:item">
				<xsl:with-param name="esc" select="@esc"/><xsl:with-param name="max" select="troll:fallback(@max,$count)"/>
			</xsl:apply-templates>
			<footer>&#160;<q><xsl:value-of select="troll:fallback($copy,$title)"/>&#160;</q></footer>
		</section>
	</xsl:template>

	<xsl:template match="atom:entry|item|rss:item|rdf:item">
		<xsl:param name="esc"/>
		<xsl:param name="max"/>
		<xsl:if test="position() &lt; $max+1">
			<xsl:variable name="d" select="atom:summary|description|rdf:description|rss:description"/>
			<xsl:variable name="l" select="atom:link/@href|link|rdf:link|rss:link"/>
			<xsl:variable name="t" select="atom:title|title|rdf:title|rss:title"/>
			<details>
				<xsl:if test="$max = 1"><xsl:attribute name="open">true</xsl:attribute></xsl:if>
				<summary>
					<xsl:call-template name="troll:link"><xsl:with-param name="url" select="$l" /><xsl:with-param name="txt" select="$t"/></xsl:call-template>
				</summary>
				<article>
					<xsl:if test="$max = 1"><xsl:attribute name="style">text-align:center</xsl:attribute></xsl:if>
					<xsl:choose>
						<xsl:when test="$esc"><xsl:value-of select="troll:strip($d)"/></xsl:when>
						<xsl:otherwise><xsl:variable name="e" select="content:encoded"/><xsl:value-of select="troll:fallback($e,$d)" disable-output-escaping="yes"/></xsl:otherwise>
					</xsl:choose>
				</article>
			</details>
		</xsl:if>
	</xsl:template>

	<xsl:function name="troll:fallback">
		<xsl:param name="fall"/>
		<xsl:param name="back"/>
		<xsl:choose>
			<xsl:when test="$fall != ''"><xsl:value-of select="$fall" disable-output-escaping="yes"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$back" disable-output-escaping="yes"/></xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<xsl:template name="troll:link">
		<xsl:param name="url"/>
		<xsl:param name="txt"/>
		<a rel="noopener noreferrer" target="_blank"><xsl:attribute name="href"><xsl:value-of select="$url"/></xsl:attribute><xsl:value-of select="troll:shorten($txt, $tax)" /></a>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:function name="troll:shorten">
		<xsl:param name="value"/>
		<xsl:param name="length"/>
		<xsl:choose>
			<xsl:when test="string-length($value) > $length"><xsl:value-of select="substring($value, 1, number($length)-3)" />...</xsl:when>
			<xsl:otherwise><xsl:value-of select="$value" /></xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<xsl:function name="troll:strip">
		<xsl:param name="value"/>
		<xsl:value-of select="replace($value, '&lt;[^&gt;]*&gt;', ' ')"/>
	</xsl:function>

</xsl:stylesheet>