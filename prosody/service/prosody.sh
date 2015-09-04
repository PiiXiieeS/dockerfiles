#!/bin/bash
exec chown prosody /var/lib/prosody && prosodyctl start
