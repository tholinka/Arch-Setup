#!/bin/sh

### From https://discourse.pi-hole.net/t/commonly-whitelisted-domains/212
## Google (Maps, Youtube, etc)
# Google Maps and other Google services
DOMAINS="$DOMAINS clients4.google.com clients2.google.com"
# YouTube history
DOMAINS="$DOMAINS s.youtube.com video-stats.l.google.com"
# Google Play
DOMAINS="$DOMAINS android.clients.google.com"
## End Google

## Microsoft (Windows, Office, Skype, etc)
# Windows uses this to verify connectivity to Internet
DOMAINS="$DOMAINS www.msftncsi.com"
# Microsoft Web Pages (Outlook, Office365, Live, Microsoft.com58…)
DOMAINS="$DOMAINS outlook.office365.com products.office.com c.s-microsoft.com i.s-microsoft.com login.live.com"
# Backup bitlocker recovery key to Microsoft account
DOMAINS="$DOMAINS g.live.com"
# Windows/Xbox store
DOMAINS="$DOMAINS dl.delivery.mp.microsoft.com geo-prod.do.dsp.mp.microsoft.com displaycatalog.mp.microsoft.com"
# used for sign-ins, new accounts, etc on xbox
DOMAINS="$DOMAINS clientconfig.passport.net"
# Microsoft says this is used for xbox achievements
DOMAINS="$DOMAINS v10.events.data.microsoft.com"
# xbox messaging
DOMAINS="$DOMAINS client-s.gateway.messenger.live.com"
# Xbox Achievements (from /r/xboxone)
DOMAINS="$DOMAINS xbox.ipv6.microsoft.com device.auth.xboxlive.com www.msftncsi.com title.mgt.xboxlive.com xsts.auth.xboxlive.com title.auth.xboxlive.com ctldl.windowsupdate.com attestation.xboxlive.com xboxexperiencesprod.experimentation.xboxlive.com xflight.xboxlive.com cert.mgt.xboxlive.com xkms.xboxlive.com def-vef.xboxlive.com notify.xboxlive.com help.ui.xboxlive.com licensing.xboxlive.com eds.xboxlive.com www.xboxlive.com v10.vortex-win.data.microsoft.com settings-win.data.microsoft.com"
# Skype
DOMAINS="$DOMAINS s.gateway.messenger.live.com client-s.gateway.messenger.live.com ui.skype.com pricelist.skype.com apps.skype.com m.hotmail.com sa.symcb.com s1.symcb.com s2.symcb.com s3.symcb.com s4.symcb.com s5.symcb.com"
# Microsoft Office
DOMAINS="$DOMAINS officeclient.microsoft.com"
## End Microsoft

# Jackbox.tv #Jackbox.tv will not load unless you whitelist google-analytics
DOMAINS="$DOMAINS www.google-analytics.com ssl.google-analytics.com"

# Spotify #The Spotify app for iOS will stop functioning unless it’s web service counterpart is whitelisted.
DOMAINS="$DOMAINS spclient.wg.spotify.com apresolve.spotify.com"

# Target's Weekly Ads
DOMAINS="$DOMAINS weeklyad.target.com m.weeklyad.target.com weeklyad.target.com.edgesuite.net"

# Facebook
DOMAINS="$DOMAINS upload.facebook.com creative.ak.fbcdn.net external-lhr0-1.xx.fbcdn.net external-lhr1-1.xx.fbcdn.net external-lhr10-1.xx.fbcdn.net external-lhr2-1.xx.fbcdn.net external-lhr3-1.xx.fbcdn.net external-lhr4-1.xx.fbcdn.net external-lhr5-1.xx.fbcdn.net external-lhr6-1.xx.fbcdn.net external-lhr7-1.xx.fbcdn.net external-lhr8-1.xx.fbcdn.net external-lhr9-1.xx.fbcdn.net fbcdn-creative-a.akamaihd.net scontent-lhr3-1.xx.fbcdn.net scontent.xx.fbcdn.net scontent.fgdl5-1.fna.fbcdn.net graph.facebook.com connect.facebook.com cdn.fbsbx.com api.facebook.com edge-mqtt.facebook.com mqtt.c10r.facebook.com portal.fb.com star.c10r.facebook.com star-mini.c10r.facebook.com b-api.facebook.com fb.me"

# DirectTV
DOMAINS="$DOMAINS directvnow.com directvapplications.hb.omtrdc.net s.zkcdn.net js.maxmind.com"

# Bild DE
#DOMAINS="$DOMAINS ec-ns.sascdn.com"

## Plex Domains
DOMAINS="$DOMAINS plex.tv tvdb2.plex.tv pubsub.plex.bz proxy.plex.bz proxy02.pop.ord.plex.bz cpms.spop10.ams.plex.bz meta-db-worker02.pop.ric.plex.bz meta.plex.bz tvthemes.plexapp.com.cdn.cloudflare.net tvthemes.plexapp.com 106c06cd218b007d-b1e8a1331f68446599e96a4b46a050f5.ams.plex.services meta.plex.tv cpms35.spop10.ams.plex.bz proxy.plex.tv metrics.plex.tv pubsub.plex.tv status.plex.tv www.plex.tv node.plexapp.com nine.plugins.plexapp.com staging.plex.tv app.plex.tv o1.email.plex.tv  o2.sg0.plex.tv dashboard.plex.tv"
# Domains used by Plex
# - custom login pictures
DOMAINS="$DOMAINS gravatar.com"
# - metadata for tv series
DOMAINS="$DOMAINS thetvdb.com"
# - metadata for movies
DOMAINS="$DOMAINS themoviedb.com"
## End plex

# Sonarr
#DOMAINS="$DOMAINS services.sonarr.tv skyhook.sonarr.tv download.sonarr.tv apt.sonarr.tv forums.sonarr.tv

# Placehold.it (Image placeholders often used during web design. Not sure why this is even blocked in the first place.)
DOMAINS="$DOMAINS placehold.it placeholdit.imgix.net"

# Dropbox
DOMAINS="$DOMAINS dl.dropboxusercontent.com ns1.dropbox.com ns2.dropbox.com"

# Fox News
DOMAINS="$DOMAINS widget-cdn.rpxnow.com"

# Images on Marketwatch.com56
DOMAINS="$DOMAINS s.marketwatch.com"

# Apple Music
DOMAINS="$DOMAINS itunes.apple.com"

# GoDaddy webmail buttons
DOMAINS="$DOMAINS imagesak.secureserver.net"

# Google Chrome (to update on ubuntu)
DOMAINS="$DOMAINS dl.google.com"

# Apple ID
DOMAINS="$DOMAINS appleid.apple.com"

# SnapChat
DOMAINS="$DOMAINS app-analytics.snapchat.com sc-analytics.appspot.com cf-st.sc-cdn.net"

# WatchESPN
DOMAINS="$DOMAINS fpdownload.adobe.com entitlement.auth.adobe.com livepassdl.conviva.com"

# NVIDIA GeForce Experience # GFE requires this to download driver updates (or events.gfe.nvidia.com, but that is also used for telemetry).
DOMAINS="$DOMAINS gfwsl.geforce.com"

# Videos not playing in times.com and nydailynews.com
DOMAINS="$DOMAINS delivery.vidible.tv img.vidible.tv videos.vidible.tv edge.api.brightcove.com cdn.vidible.tv"

# Bing Maps Platform
DOMAINS="$DOMAINS dev.virtualearth.net ecn.dev.virtualearth.net t0.ssl.ak.dynamic.tiles.virtualearth.net t0.ssl.ak.tiles.virtualearth.net"

# Google Play Android updates
DOMAINS="$DOMAINS android.clients.google.com"

# Moto phones OS updates
DOMAINS="$DOMAINS appspot-preview.l.google.com"

## Captive-portal tests
# Android/Chrome
DOMAINS="$DOMAINS connectivitycheck.android.com android.clients.google.com clients3.google.com  connectivitycheck.gstatic.com"
# Windows/Microsoft
DOMAINS="$DOMAINS msftncsi.com www.msftncsi.com ipv6.msftncsi.com"
#iOS/Apple (not old iOS verisons)
DOMAINS="$DOMAINS captive.apple.com gsp1.apple.com www.apple.com www.appleiphonecell.com"
## End Capitive-portal

# Grand Theft Auto V Online PC
DOMAINS="$DOMAINS prod.telemetry.ros.rockstargames.com"
### END discourse.pi-hole.net

### From https://wally3k.github.io/
## Amazon Web Services (Kowabit)
DOMAINS="$DOMAINS s3.amazonaws.com"

## Google Content (Andy Short)
DOMAINS="$DOMAINS clients2.google.com clients3.google.com clients4.google.com clients5.google.com"

## Link Shortners (Openphish, Hostsfile.org)
DOMAINS="$DOMAINS www.bit.ly bit.ly ow.ly j.mp goo.gl tinyurl.com"

## Microsoft Connectivity Checker (Mahakala)
DOMAINS="$DOMAINS msftncsi.com www.msftncsi.com"

## EA / Origin (Mahakala, Andy Short, Cameleon & others)
DOMAINS="$DOMAINS ea.com"
#(Used by Origin for content delivery)
DOMAINS="$DOMAINS cdn.optimizely.com"

## Blocked by Mahakala
# (Used by Facebook for image uploads)
DOMAINS="$DOMAINS res.cloudinary.com"
# (Others)
DOMAINS="$DOMAINS gravatar.com rover.ebay.com imgs.xkcd.com"

## Blocked by Andy Short
DOMAINS="$DOMAINS netflix.com"
# (Used by Gizmodo sites)
DOMAINS="$DOMAINS alluremedia.com.au"
# (Others)
DOMAINS="$DOMAINS tomshardware.com"

## Blocked by Reddestdream
# (Used by Apple devices for certificate validation)
DOMAINS="$DOMAINS ocsp.apple.com"

## Blocked by various lists
DOMAINS="$DOMAINS cdn.shopify.com s.shopify.com"
# (Malwarebytes server)
DOMAINS="$DOMAINS keystone.mwbsys.com"
# (Others)
DOMAINS="$DOMAINS dl.dropbox.com api.ipify.org"
### End wally3k

### My own
# i.imgur.com
DOMAINS="$DOMAINS prod.imgur.map.fastlylb.net"

# fonts.googleapis.com
DOMAINS="$DOMAINS googleadapis.l.google.com"

# fonts.gstatic.com
DOMAINS="$DOMAINS gstaticadssl.l.google.com"

# twitter link shortner
DOMAINS="$DOMAINS t.co"

# youtube link shortner
DOMAINS="$DOMAINS youtu.be"

# newegg links
DOMAINS="$DOMAINS anrdoezrs.net"

# patreon (and other websites that use the service) email links
DOMAINS="$DOMAINS mandrillapp.com"

# humblebundle images (humblebundle.imgix.net redirect)
DOMAINS="$DOMAINS global.imgix.map.fastly.net"

# cwtv.com (though nanodefender fixes it)
DOMAINS="$DOMAINS cwtv-prod-elb.digitalsmiths.net cwtv-mrss-akamai.cwtv.com imasdk.googleapis.com app.link"

# click.email.roosterteeth.com (unsub from roosterteeth emails)
DOMAINS="$DOMAINS click.virt.s7.exacttarget.com"

# www.bing.com
DOMAINS="$DOMAINS a-0001.a-msedge.net"

# www.live.com
DOMAINS="$DOMAINS a-0010.a-msedge.net"

# twitter.com images
DOMAINS="$DOMAINS pbs.twimg.com"

# tinyurl.com
DOMAINS="$DOMAINS tinyurl.com"

# serverfault.com
DOMAINS="$DOMAINS serverfault.com"

# www.spotify.com
DOMAINS="$DOMAINS weblb-wg.dual-gslb.spotify.com"

# www.howtogeek.com
DOMAINS="$DOMAINS www.howtogeek.com"

# medium.com
DOMAINS="$DOMAINS medium.com"

# fidelity.com statement viewer
DOMAINS="$DOMAINS nexus.ensighten.com"

# aws
DOMAINS="$DOMAINS aws.amazon.com"

# random local websites
DOMAINS="$DOMAINS eteamz.com www.eteamz.com"

# filesharing site
DOMAINS="$DOMAINS my.mixtape.moe"

# stitcher podcast website
DOMAINS="$DOMAINS www.stitcher.com"

# istherenaydeal links
DOMAINS="$DOMAINS www.jdoqocy.com cj.dotomi.com www.emjcd.com"

# supermicro
DOMAINS="$DOMAINS www.supermicro.com supermicro.com"

# students.robinhood.com
DOMAINS="$DOMAINS bnc.lt"

# osrs, seems to have gotten caught up in blacklisting of malware lookalikes
DOMAINS="$DOMAINS runescape.com oldschool.runescape.com"

# coinbase
DOMAINS="$DOMAINS www.coinbase.com coinbase.com pro.coinbase.com api.coinbase.com assets.coinbase.com images.coinbase.com binance.com"

# unsubscribe from coinbase
DOMAINS="$DOMAINS mixpanel.com"

# miningpoolhub, mining group
DOMAINS="$DOMAINS miningpoolhub.com us-east.cryptonight-hub.miningpoolhub.com"

# github.com tar.gz download
DOMAINS="$DOMAINS codeload.github.com"

# class survey
DOMAINS="$DOMAINS qualtrics.com und.qualtrics.com"

# discord
DOMAINS="$DOMAINS cdn.discordapp.com"

# Google Forms link
DOMAINS="$DOMAINS forms.gle"

# Gleam promo's
DOMAINS="$DOMAINS gleam.io"

# honey coupons
DOMAINS="$DOMAINS joinhoney.com d.joinhoney.com s.joinhoney.com"

# windows store / updates
DOMAINS="$DOMAINS slscr.update.microsoft.com"

# teams / office
DOMAINS="$DOMAINS self.events.data.microsoft.com"

# brandonsanderson.com
DOMAINS="$DOMAINS hb.wpmucdn.com"

# msn
DOMAINS="$DOMAINS www.msn.com"

# jobs
DOMAINS="$DOMAINS boards.greenhouse.io dpm.demdex.net"

# opengapps.org
DOMAINS="$DOMAINS storage.googleapis.com"

# Mining
DOMAINS="$DOMAINS nanopool.org"

# diploma
DOMAINS="$DOMAINS trackemail.parchment.com"

# email tracking link -.-
DOMAINS="$DOMAINS e.customeriomail.com"
### End my own

### Whitelist items
# Add anudeepND's whitelist first, then add these on top of it
# from https://github.com/anudeepND/whitelist/blob/master/scripts/whitelist.sh#L28
echo "Downloading anudeepND's whitelist"
pihole -w $(curl -sS https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt)

# unquoted so the spaces spit then into new arguments
echo "Adding more domains to whitelist"
pihole -w $DOMAINS

echo "Done"
