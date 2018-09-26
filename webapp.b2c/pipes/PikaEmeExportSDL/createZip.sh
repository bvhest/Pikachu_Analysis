#!/bin/bash

cd /ebizdata/pikafsq1/ClobFilestore &&
zip /ebizdata/pikaq1/data/PikaEmeExportSDL/archive/PMS_export.zip -@ < /ebizdata/pikaq1/data/PikaEmeExportSDL/outbox/OCTL_filestore.list &&
cd /ebizdata/pikaq1/data/PikaEmeExportSDL/outbox &&
zip ../archive/PMS_export.zip *
