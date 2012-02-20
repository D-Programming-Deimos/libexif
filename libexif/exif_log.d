// libexif 0.6.20 header translated to the D programming language
// by Lars Tandle Kyllingstad (2012).
module libexif.exif_log;
import core.stdc.config;


/*! \file exif-log.h
 *  \brief Log message infrastructure
 */
/*
 * Copyright (c) 2004 Lutz Mueller <lutz@users.sourceforge.net>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful, 
 * but WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details. 
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA  02110-1301  USA.
 */

nothrow extern (C):


public import libexif.exif_mem;
public import core.stdc.stdarg;

/*! State maintained by the logging interface */
alias void ExifLog;

/*! Create a new logging instance.
 * \see exif_log_free
 *
 * \return new instance of #ExifLog
 */
ExifLog *exif_log_new     ();
ExifLog *exif_log_new_mem (ExifMem *);
void     exif_log_ref     (ExifLog *log);
void     exif_log_unref   (ExifLog *log);

/*! Delete instance of #ExifLog.
 * \see exif_log_new
 *
 * \param[in] log #ExifLog
 * \return new instance of #ExifLog
 */
void     exif_log_free    (ExifLog *log);

enum {
	EXIF_LOG_CODE_NONE,
	EXIF_LOG_CODE_DEBUG,
	EXIF_LOG_CODE_NO_MEMORY,
	EXIF_LOG_CODE_CORRUPT_DATA
}
alias typeof(EXIF_LOG_CODE_NONE) ExifLogCode;

/*! Return a textual description of the given class of error log.
 *
 * \param[in] code logging message class
 * \return textual description of the log class
 */
const (char) *exif_log_code_get_title   (ExifLogCode code);

/*! Return a verbose description of the given class of error log.
 *
 * \param[in] code logging message class
 * \return verbose description of the log class
 */
const (char) *exif_log_code_get_message (ExifLogCode code);

/*! Log callback function prototype.
 */
alias void function(ExifLog *log, ExifLogCode, const (char) *domain,
			      const (char) *format, va_list args, void *data) ExifLogFunc;

/*! Register log callback function.
 * Calls to the log callback function are purely for diagnostic purposes.
 *
 * \param[in] log logging state variable
 * \param[in] func callback function to set
 * \param[in] data data to pass into callback function
 */
void     exif_log_set_func (ExifLog *log, ExifLogFunc func, void *data);

void     exif_log  (ExifLog *log, ExifLogCode, const (char) *domain,
		    const (char) *format, ...);

void     exif_logv (ExifLog *log, ExifLogCode, const (char) *domain,
		    const (char) *format, va_list args);

/* For your convenience */
void EXIF_LOG_NO_MEMORY(ExifLog* l, const(char)* d, c_ulong s)
{
    exif_log ((l), EXIF_LOG_CODE_NO_MEMORY, (d), "Could not allocate %lu byte(s).", (s));
}

