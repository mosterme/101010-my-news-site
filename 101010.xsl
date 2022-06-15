<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://my.netscape.com/rdf/simple/0.9/" xmlns:rss="http://purl.org/rss/1.0/" xmlns:troll="http://random.pwnz.org" exclude-result-prefixes="troll">
	<!-- also see https://www.saxonica.com/saxon-js/index.xml or -->
	<!-- do   saxon -xsl:101010.xsl -s:config.xml -o:output.html -->
	<xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes"/>
	<xsl:variable name="title" select="'101010 - my news site'"/>
	<xsl:variable name="path" select="'assets'"/> <!-- path to assets -->
	<xsl:variable name="home" select="'𝓗'"/> <!-- ℍ 𝓗 ⌂ 🗟 -->
	<xsl:variable name="feed" select="'𝓕'"/> <!-- 𝔽 𝓕 -->
	<xsl:variable name="icon"  select="troll:fallback(//config/@icon,'📰')"/> <!-- 🌎 🌍 🌏 📰 👓 🛸 🛰️ 🚀 -->
	<xsl:variable name="color" select="troll:fallback(//config/@color,'blue.css')"/>
	<xsl:variable name="style" select="troll:fallback(//config/@style,'101010.css')"/>
	<xsl:variable name="count" select="troll:fallback(//config/@max,10)"/>
	<xsl:variable name="basic" select="'common.css'"/>

	<xsl:template match="/">
		<html>
			<head>
				<title><xsl:value-of select="$title"/> - <xsl:value-of select="format-time(current-time(), '[H01]:[m01]:[s01]')"/></title>
				<link rel="stylesheet" type="text/css" href="{$path}/{$basic}"/>
				<link rel="stylesheet" type="text/css" href="{$path}/{$color}"/>
				<link rel="stylesheet" type="text/css" href="{$path}/{$style}"/>
				<link rel="icon" href="data:image/svg+xml,&lt;svg xmlns='http://www.w3.org/2000/svg'>&lt;text y='26' font-size='26'>{$icon}&lt;/text>&lt;/svg>"/>
			</head>
			<body>
				<header>
					<time><xsl:value-of select="format-time(current-time(), '[H01]:[m01]:[s01]')"/></time>
					<h1><span><xsl:value-of select="$icon"/></span> <xsl:value-of select="$title"/></h1>
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
				<h2><xsl:attribute name="title" select="$desc"/>
					<xsl:value-of select="$title"/><xsl:text> </xsl:text>
					<xsl:call-template name="troll:link"><xsl:with-param name="url" select="$link"/><xsl:with-param name="txt" select="$home"/></xsl:call-template>
					<xsl:call-template name="troll:link"><xsl:with-param name="url" select="."/><xsl:with-param name="txt" select="$feed"/></xsl:call-template>
				</h2>
			</header>
			<xsl:apply-templates select="document(.)//atom:entry|document(.)//item|document(.)//rdf:item|document(.)//rss:item">
				<xsl:with-param name="max" select="troll:fallback(@max,$count)"/>
			</xsl:apply-templates>
			<footer>&#160;<q><xsl:value-of select="troll:fallback($copy,$title)"/>&#160;</q></footer>
		</section>
	</xsl:template>

	<xsl:template match="atom:entry|item|rss:item|rdf:item">
		<xsl:param name="max"/>
		<xsl:if test="position() &lt; $max+1">
			<xsl:variable name="title" select="atom:title|title|rdf:title|rss:title"/>
			<xsl:variable name="text" select="troll:fallback(content:encoded,atom:summary|description|rdf:description|rss:description)"/>	
			<xsl:variable name="link" select="atom:link/@href|link|rdf:link|rss:link"/>
			<details><xsl:if test="$max = 1"><xsl:attribute name="open"/></xsl:if>
				<summary>
					<xsl:call-template name="troll:link"><xsl:with-param name="url" select="$link"/><xsl:with-param name="txt" select="$title"/></xsl:call-template>
					<xsl:text> </xsl:text><span><xsl:value-of select="substring-after(troll:strip($text),substring-before($title,'...'))"/></span>
				</summary>
				<article><xsl:if test="$max = 1"><xsl:attribute name="style" select="'text-align:center'"/></xsl:if>
					<xsl:value-of select="$text" disable-output-escaping="yes"/>
				</article>
			</details>
		</xsl:if> 
	</xsl:template>

	<xsl:function name="troll:fallback">
		<xsl:param name="fall"/> <xsl:param name="back"/>
		<xsl:choose>
			<xsl:when test="$fall != ''"><xsl:value-of select="$fall" disable-output-escaping="yes"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$back" disable-output-escaping="yes"/></xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<xsl:template name="troll:link">
		<xsl:param name="url"/> <xsl:param name="txt"/>
		<a rel="noopener noreferrer" target="_blank"><xsl:attribute name="href"><xsl:value-of select="$url"/></xsl:attribute><xsl:value-of select="$txt" /></a>
	</xsl:template>

	<xsl:function name="troll:strip">
		<xsl:param name="value"/> <xsl:value-of select="replace($value, '&lt;[^&gt;]*&gt;', '')"/>
	</xsl:function>

</xsl:stylesheet>