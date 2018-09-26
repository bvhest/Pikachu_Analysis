<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml CE_CategorizationTree.xml?>
<!-- version 1.0	nly92174	21.03.2007		new 	-->
<!-- version 1.1	nly92174	27.03.2007	taking into account optional trans tags in the translated text	-->
<!-- version 1.3	nly90671	12.04.2007		added length overflow block	-->
<!-- version 1.3	nly90671	12.04.2007		made it possible to combine both previews in one XSLT	-->
<!-- version 1.5	nly90671	26.06.2007		corrected productname display	-->
<!-- version 1.5	nly90671	26.06.2007		corrected popup	-->
<!-- version 1.6	nly90671	19.11.2007		added brandstuff	-->
<!-- version 1.7	nly90671	28.02.2007		added support for images, added support for xUCDM 1.,1, added support for packaging -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:sql="http://apache.org/cocoon/SQL/2.0" version="2.0">
	<!-- -->
	<xsl:template match="/Categorization" mode="cat">
		<html>
			<xsl:call-template name="cat_head"/>
			<body contentID="content">
				<div class="philips-body">
					<xsl:apply-templates mode="cat"/>
				</div>
			</body>
		</html>
	</xsl:template>
	<!-- -->
	<xsl:template name="cat_head">
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
			<xsl:call-template name="cat_head_style"/>
		</head>
	</xsl:template>
	<!-- -->
	<xsl:template name="cat_head_style">
		<style type="text/css">
		.philips-body {
			font-family:Verdana, Arial, Helvetica, sans-serif;
			font-size:70%;
			color:#252F47;
			background-color:#FFFFFF; 
			line-height:17px;
			margin:0px;
			/*margin-top: 25px;*/
		}

		.p-center{
			text-align:center;
		}

		h1 {
			text-align:left;
			font-size:22px;
			padding:6px 5px 5px 8px;
			font-weight:normal;
			color:#B9BBC7;
			margin:0px;
			margin-left:1px;
			line-height:normal;
		}

		h4{
			margin:0px;
			font-size:120%;
			color:#2554C7;
		}

		h5 {
			margin:15px;
			font-size:110%;
			color:#2B60DE;
			display:inline;
		}
		
		h6 {
			margin:30px;
			font-size:100%;
			color:#000077;
			display:inline;
		}
		
		.p-product-general{
			border-collapse:collapse;
			border-spacing:0px;
			width:560px;
			margin-bottom:10px;
		}

		</style>
	</xsl:template>
	<!-- -->
	<xsl:template match="Catalog" mode="cat">
		<!--  -->
		<table cellspacing="0" class="p-product-general">
			<tr>
				<td valign="top">
					<h2 style="margin:6px 0px">
						<xsl:call-template name="cat_show">
							<xsl:with-param name="node" select="CatalogName"/>
						</xsl:call-template>
					</h2>
					<br/>
					<!-- -->
					<xsl:apply-templates select="FixedCategorization/Group" mode="cat"/>
					<br/>
				</td>
			</tr>
		</table>
		<!-- -->
	</xsl:template>
	<!-- -->
	<xsl:template match="FixedCategorization/Group" mode="cat">
		<h4>
			<xsl:call-template name="cat_show">
				<xsl:with-param name="node" select="GroupName"/>
			</xsl:call-template>
		</h4>
		<xsl:apply-templates select="Category" mode="cat"/>
		<br/>
	</xsl:template>
	<xsl:template match="Category" mode="cat">
		<h5>
			<xsl:call-template name="cat_show">
				<xsl:with-param name="node" select="CategoryName"/>
			</xsl:call-template>
			<br/>
		</h5>
		<xsl:apply-templates select="SubCategory/SubCategoryName" mode="cat"/>
		<br/>
	</xsl:template>
	<xsl:template match="SubCategory/SubCategoryName" mode="cat">
		<h6>
			<xsl:choose>
				<xsl:when test="@translate='yes'">
					<xsl:call-template name="cat_show">
						<xsl:with-param name="node" select="."/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
			<br/>
		</h6>
	</xsl:template>
	<!-- -->
	<xsl:template match="*|@*" mode="cat">
		<!-- catch all: do nothing -->
	</xsl:template>
	<!-- -->
	<xsl:template name="cat_show">
		<xsl:param name="node"/>
		<xsl:value-of select="$node"/>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
