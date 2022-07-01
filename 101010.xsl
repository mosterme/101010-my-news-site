<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://my.netscape.com/rdf/simple/0.9/" xmlns:rss="http://purl.org/rss/1.0/" xmlns:troll="http://random.pwnz.org" exclude-result-prefixes="atom content dc rdf rss troll">
	<!-- also see https://www.saxonica.com/saxon-js/index.xml or -->
	<!-- do   saxon -xsl:101010.xsl -s:config.xml -o:output.html -->
	<xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes"/>
	<xsl:variable name="title" select="'101010 - my news site'"/>
	<xsl:variable name="basic" select="'common.css'"/>
	<xsl:variable name="home" select="'𝓗'"/> <!-- ℍ 𝓗 ⌂ 🗟 -->
	<xsl:variable name="feed" select="'𝓕'"/> <!-- 𝔽 𝓕 -->
	<xsl:variable name="path"  select="troll:fallback(//config/@path,'assets')"/> <!-- path to assets -->
	<xsl:variable name="icon"  select="troll:fallback(//config/@icon,'📰')"/> <!-- 🌎 🌍 🌏 📰 👓 🛸 🛰️ 🚀 -->
	<xsl:variable name="color" select="troll:fallback(//config/@color,'blue.css')"/>
	<xsl:variable name="theme" select="troll:fallback(//config/@theme,'101010.css')"/>
	<xsl:variable name="count" select="troll:fallback(//config/@max,10)"/>

	<xsl:template match="/">
		<html>
			<head>
				<title><xsl:value-of select="$title"/> - <xsl:value-of select="format-time(current-time(), '[H01]:[m01]:[s01]')"/></title>
				<link rel="stylesheet" type="text/css" id="basic" href="{$path}/basic/{$basic}"/>
				<link rel="stylesheet" type="text/css" id="color" href="{$path}/color/{$color}"/>
				<link rel="stylesheet" type="text/css" id="theme" href="{$path}/theme/{$theme}"/>
				<link rel="icon" href="data:image/svg+xml,&lt;svg xmlns='http://www.w3.org/2000/svg'>&lt;text y='26' font-size='26'>{$icon}&lt;/text>&lt;/svg>"/>
			</head>
			<body>
				<header>
					<time><xsl:value-of select="format-time(current-time(), '[H01]:[m01]:[s01]')"/></time>
					<h1><span class="hi"><xsl:value-of select="$icon"/></span> <span class="ht"><xsl:value-of select="$title"/></span></h1>
				</header>
				<main>
					<menu><xsl:apply-templates select="//feed" mode="menu"/></menu>
					<xsl:apply-templates select="//feed"/>
				</main>
				<footer id="x"><a href="#about">about</a> | <a href="#config">config</a> | <a href="#help">help</a></footer>
				<aside id="about"><div class="popup"><h2>101010 - my news site</h2><a class="close" href="#x">×</a><center class="content"><p>a simple news aggregator website. inspired by old sites like <a rel="noopener noreferrer" target="_blank" href="https://web.archive.org/web/20101010101010/mynewssite.org">mynewssite.org</a>.</p><p><img src="{$path}/image/blue-101010.png" alt="blue 101010"/></p><p>proudly made <em>without</em> docker, javascript, php, python, mysql or postgresql.</p></center></div></aside>
				<aside id="config"><div class="popup"><h2>config.xml</h2><a class="close" href="#x">×</a><pre class="content"><xsl:apply-templates select="/" mode="echo"/></pre><xsl:call-template name="troll:options"/></div></aside>
				<aside id="help"><div class="popup"><h2>Check the <a rel="noopener noreferrer" target="_blank" href="https://github.com/mosterme/101010-my-news-site/wiki">Wiki</a> for information about ...</h2><a class="close" href="#x">×</a><ul class="content"><li><a rel="noopener noreferrer" target="_blank" href="https://github.com/mosterme/101010-my-news-site/wiki/Requirements">Requirements</a></li><li><a rel="noopener noreferrer" target="_blank" href="https://github.com/mosterme/101010-my-news-site/wiki/Quickstart">Quickstart</a></li><li><a rel="noopener noreferrer" target="_blank" href="https://github.com/mosterme/101010-my-news-site/wiki/Configuration">Configuration</a></li><li><a rel="noopener noreferrer" target="_blank" href="https://github.com/mosterme/101010-my-news-site/wiki/Which-sites-are-supported%3F">Supported sites</a></li></ul></div></aside>
				<script>function swapcss(name, sheet) { document.getElementById(name).setAttribute("href", "<xsl:value-of select="$path"/>" + "/" + name + "/" + sheet) }</script>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="feed">
		<section>
			<xsl:variable name="title" select="document(.)/atom:feed/atom:title|document(.)//channel/title|document(.)//rdf:channel/rdf:title|document(.)//rss:channel/rss:title"/>
			<xsl:variable name="copy"  select="document(.)/atom:feed/atom:rights|document(.)//copyright|document(.)//rdf:copyright|document(.)//rss:copyright|document(.)//dc:rights"/>
			<xsl:variable name="desc"  select="document(.)/atom:feed/atom:subtitle|document(.)//channel/description|document(.)//rdf:channel/rdf:description|document(.)//rss:channel/rss:description"/>
			<xsl:variable name="link"  select="document(.)/atom:feed/atom:link[not(@rel='self')][not(@rel='hub')]/@href|document(.)//channel/link|document(.)//rdf:channel/rdf:link|document(.)//rss:channel/rss:link"/>
			<xsl:attribute name="id" select="generate-id($link)"/>
			<header>
				<h2><xsl:attribute name="title" select="$desc"/>
					<xsl:value-of select="$title"/><xsl:text> </xsl:text>
					<a rel="noopener noreferrer" target="_blank"><xsl:attribute name="href" select="$link"/><xsl:value-of select="$home"/></a>
					<a rel="noopener noreferrer" target="_blank"><xsl:attribute name="href" select="."/><xsl:value-of select="$feed"/></a>
				</h2>
			</header>
			<xsl:apply-templates select="document(.)//atom:entry|document(.)//item|document(.)//rdf:item|document(.)//rss:item">
				<xsl:with-param name="max" select="troll:fallback(@max,$count)"/>
			</xsl:apply-templates>
			<footer>&#160;<q><xsl:value-of select="troll:fallback($copy,$title)"/>&#160;</q></footer>
		</section>
	</xsl:template>

	<xsl:template match="feed" mode="menu">
		<li><a>
			<xsl:variable name="title" select="document(.)/atom:feed/atom:title|document(.)//channel/title|document(.)//rdf:channel/rdf:title|document(.)//rss:channel/rss:title"/>
			<xsl:variable name="link"  select="document(.)/atom:feed/atom:link[not(@rel='self')][not(@rel='hub')]/@href|document(.)//channel/link|document(.)//rdf:channel/rdf:link|document(.)//rss:channel/rss:link"/>
			<xsl:attribute name="href" select="concat('#', generate-id($link))"/> <xsl:value-of select="troll:fallback(substring-before($title, ' - '), $title)"/>
		</a></li>
	</xsl:template>

	<xsl:template match="atom:entry|item|rss:item|rdf:item">
		<xsl:param name="max"/>
		<xsl:if test="position() &lt; $max+1">
			<xsl:variable name="rfc2822" select="'^(\w{3}, )?\d{1,2} \w{3} \d{4} \d{2}:\d{2}:\d{2} ([+-]?\d{4}|\w{3,4})$'"/>
			<xsl:variable name="iso8601" select="'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?(([+-]\d{2}:\d{2})|Z)$'"/>
			<xsl:variable name="day8601" select="'^\d{4}-\d{2}-\d{2}$'"/> <!-- iso 8601, but just the date portion -->
			<xsl:variable name="dateorig" select="atom:published|dc:date|pubDate"/>
			<xsl:variable name="datetime"><xsl:choose>
				<xsl:when test="$dateorig = ''"></xsl:when>
				<xsl:when test="matches($dateorig, $rfc2822)"><xsl:value-of select="parse-ietf-date(replace($dateorig, 'CEST','+0200'))"/></xsl:when>
				<xsl:when test="matches($dateorig, $iso8601)"><xsl:value-of select="$dateorig"/></xsl:when>
				<xsl:when test="matches($dateorig, $day8601)"><xsl:value-of select="$dateorig"/>T00:00:00</xsl:when>
			</xsl:choose></xsl:variable>
			<xsl:variable name="title" select="atom:title|title|rdf:title|rss:title"/>
			<xsl:variable name="text" select="troll:fallback(content:encoded,atom:summary|description|rdf:description|rss:description)"/>
			<xsl:variable name="link" select="atom:link/@href|link|rdf:link|rss:link"/>
			<details><xsl:if test="$max = 1"><xsl:attribute name="open"/></xsl:if>
				<summary>
					<a rel="noopener noreferrer" target="_blank"><xsl:attribute name="href" select="$link"/><xsl:value-of select="$title"/></a>
					<xsl:text> </xsl:text><span><xsl:value-of select="substring-after(replace($text, '&lt;[^&gt;]*&gt;', ''),substring-before($title,'...'))"/></span>
				</summary>
				<!-- format-dateTime($datetime, '[FNn,3-3], [D] [MNn,3-3] [Y] [H01]:[m01]') -->
				<xsl:if test="$dateorig!=''"><time><xsl:attribute name="datetime" select="adjust-dateTime-to-timezone($datetime)"/><xsl:value-of select="format-dateTime($datetime, '[FNn,3-3], [D] [MNn,3-3] [Y] [H01]:[m01]')"/></time></xsl:if>
				<article><xsl:if test="$max = 1"><xsl:attribute name="style" select="'text-align:center'"/></xsl:if>
					<xsl:value-of select="$text" disable-output-escaping="yes"/>
				</article>
			</details>
		</xsl:if> 
	</xsl:template>

    <xsl:template match="*" mode="echo">&lt;<xsl:value-of select="name()"/><xsl:apply-templates select="@*" mode="echo"/>&gt;<xsl:apply-templates mode="echo"/>&lt;/<xsl:value-of select="name()"/>&gt;</xsl:template>
    <xsl:template match="@*" mode="echo"><xsl:text> </xsl:text><xsl:value-of select="name()"/>="<xsl:value-of select="."/>"</xsl:template> <xsl:template match="text()" mode="echo"><xsl:value-of select="."/></xsl:template>

	<xsl:function name="troll:fallback">
		<xsl:param name="fall"/> <xsl:param name="back"/>
		<xsl:choose>
			<xsl:when test="$fall != ''"><xsl:value-of select="$fall" disable-output-escaping="yes"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$back" disable-output-escaping="yes"/></xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<xsl:template name="troll:options">
		<xsl:if test="//config/@beta">
			<form class="content">
				<br/><hr/><br/> <label for="color">color = </label>
				<select name="color" onchange="swapcss('color', this.value)">
					<option><xsl:if test="$color = 'blue.css'"><xsl:attribute name="selected"/></xsl:if>blue.css</option>
					<option><xsl:if test="$color = 'flat.css'"><xsl:attribute name="selected"/></xsl:if>flat.css</option>
					<option><xsl:if test="$color = 'green.css'"><xsl:attribute name="selected"/></xsl:if>green.css</option>
					<option><xsl:if test="$color = 'retro.css'"><xsl:attribute name="selected"/></xsl:if>retro.css</option>
					<option><xsl:if test="$color = 'solarized.css'"><xsl:attribute name="selected"/></xsl:if>solarized.css</option>
				</select>
				&#160;&#160;&#160; <label for="theme">theme = </label>
				<select name="theme" onchange="swapcss('theme', this.value)">
					<option><xsl:if test="$theme = '101010.css'"><xsl:attribute name="selected"/></xsl:if>101010.css</option>
					<option><xsl:if test="$theme = 'planet.css'"><xsl:attribute name="selected"/></xsl:if>planet.css</option>
					<option><xsl:if test="$theme = 'reader.css'"><xsl:attribute name="selected"/></xsl:if>reader.css</option>
					<option><xsl:if test="$theme = 'slash.css'"><xsl:attribute name="selected"/></xsl:if>slash.css</option>
				</select>
			</form>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
