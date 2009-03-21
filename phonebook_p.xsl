
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match='blackbook'>
        <html>
            <head>
                <link rel='stylesheet' type='text/css' href='printstyle.css'/>
            </head>
            <body>
                <center>
                    <table class='main' cellspacing='0' cellpadding='0'>
                        <tbody>
                            <!--<tr>
                                <th id='jobtitle'>Должность</th>
                                <th id='name'>ФИО</th>
                                <th id='intphone'>Внутр</th>
                                <th id='mobile'>Мобильный</th>
                                <th id='speed'>Быстр</th>
                                <th id='email'>Email</th>
                            </tr>-->
                            <tr>
                                <td colspan='6'>
                                    <xsl:apply-templates select='company'/>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </center>
            </body>
        </html>
    </xsl:template>


    <xsl:template match='company'>
        <table width='100%' height='100%' cellspacing='0' cellpadding='0'>
            <tr>
                <th id='companyname' colspan='6'>
                    <xsl:value-of select='@name'/>
                </th>
            </tr>
            <xsl:apply-templates select='dep'/>
        </table>
    </xsl:template>

    <xsl:template match='dep'>
        <tr>
            <th id = 'depname'>
                <xsl:choose>
                    <xsl:when test="@name!='-'">
                        <xsl:value-of select='@name'/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text disable-output-escaping="yes">&#160;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </th>
            <td id='depcontent' colspan='5'>
                <table width='100%' height='100%' cellspacing='0' cellpadding='0'>
                    <xsl:for-each select='fax'>
                        <tr>
                            <td id='titlename'>&#160;</td>
                            <td>
                                <table width='100%' height='100%' cellspacing='0' cellpadding='0'>
                                    <tr>
                                        <td id='faxname'>
                                            <xsl:value-of select='name'/>
                                        </td>
                                        <td id='faxvalue'>
                                            <xsl:value-of select='value'/>
                                        </td>

                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </xsl:for-each>
                    <xsl:apply-templates select='title'/>
                </table>
            </td>
            </tr>
    </xsl:template>

    <xsl:template match='title'>
        <tr>
            <td id='titlename'>
                <xsl:choose>
                    <xsl:when test="@name!='-'">
                        <xsl:value-of select='@name'/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text disable-output-escaping="yes">&#160;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <td>
                <table width='100%' height='100%' colspan='5' cellspacing='0' cellpadding='0'>
                    <xsl:apply-templates select='human'/>
                </table>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match='human'>
        <tr>
            <td id='hname'>
                <table cellspacing='0' cellpadding='0' border='0' width='100%'>
                    <tr>
                        <td id='hlastname'>
                            <xsl:value-of select='lastname'/>
                        </td>
                        <td id='hfirstname'>
                            <xsl:value-of select='firstname'/>
                        </td>
                    </tr>
                </table>
            </td>
            <td id='intphone'>
                <xsl:value-of select='intphone'/>
            </td>
            <td id='mobile'>
                <xsl:value-of select='mobile'/>
            </td>
            <td id='speed'>
                <xsl:value-of select='speed'/>
            </td>
            <td id='email'>
                <xsl:variable name='email'>
                    <xsl:value-of select='email'/>
                </xsl:variable>
                <xsl:variable name='semail'>
                    <xsl:value-of select='semail'/>
                </xsl:variable>
                <a href="mailto:{$email}">
                    <xsl:value-of select='$semail'/>
                </a>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>
