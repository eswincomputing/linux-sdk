do_install() {
	install -d ${D}${sysconfdir}
	install -D -m 0644 ${WORKDIR}/inittab ${D}${sysconfdir}/inittab
	tmp="${SERIAL_CONSOLES}"
	[ -n "$tmp" ] && echo >> ${D}${sysconfdir}/inittab
	for i in $tmp
	do
		j=`echo ${i} | sed s/\;/\ /g`
		id=`echo ${i} | sed -e 's/^.*;//' -e 's/;.*//'`
		echo "$id::respawn:${base_bindir}/sh" >> ${D}${sysconfdir}/inittab
	done

}

