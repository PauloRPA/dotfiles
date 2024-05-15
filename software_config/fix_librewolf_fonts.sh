mkdir -p ~/.var/app/io.gitlab.librewolf-community/config/fontconfig/         
touch ~/.var/app/io.gitlab.librewolf-community/config/fontconfig/fonts.conf

cat >> ~/.var/app/io.gitlab.librewolf-community/config/fontconfig/fonts.conf << EOF
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
    <!-- Disable bitmap fonts. -->
    <selectfont><rejectfont><pattern>
        <patelt name="scalable"><bool>false</bool></patelt>
    </pattern></rejectfont></selectfont>
</fontconfig>
EOF


