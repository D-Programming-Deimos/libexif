// libexif 0.6.20 header translated to the D programming language
// by Lars Tandle Kyllingstad (2012).
module deimos.libexif.exif_content;


/*! \file exif-content.h
 *  \brief Handling EXIF IFDs
 */
/*
 * Copyright (c) 2001 Lutz Mueller <lutz@users.sourceforge.net>
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


/*! Holds all EXIF tags in a single IFD */
alias _ExifContent        ExifContent;
alias void                ExifContentPrivate;

public import deimos.libexif.exif_tag;
public import deimos.libexif.exif_entry;
public import deimos.libexif.exif_data;
public import deimos.libexif.exif_log;
public import deimos.libexif.exif_mem;

struct _ExifContent
{
        ExifEntry **entries;
        uint count;

	/*! Data containing this content */
	ExifData *parent;

	ExifContentPrivate *priv;
}

/* Lifecycle */
ExifContent *exif_content_new     ();
ExifContent *exif_content_new_mem (ExifMem *);
void         exif_content_ref     (ExifContent *content);
void         exif_content_unref   (ExifContent *content);
void         exif_content_free    (ExifContent *content);

/*! Add an EXIF tag to an IFD.
 * If this tag already exists in the IFD, this function does nothing.
 * \pre The "tag" member of the entry must be set on entry.
 *
 * \param[out] c IFD
 * \param[in] entry EXIF entry to add
 */
void         exif_content_add_entry    (ExifContent *c, ExifEntry *entry);

/*! Remove an EXIF tag from an IFD.
 * If this tag does not exist in the IFD, this function does nothing.
 *
 * \param[out] c IFD
 * \param[in] e EXIF entry to remove
 */
void         exif_content_remove_entry (ExifContent *c, ExifEntry *e);

/*! Return the #ExifEntry in this IFD corresponding to the given tag.
 * This is a pointer into a member of the #ExifContent array and must NOT be
 * freed or unrefed by the caller.
 *
 * \param[in] content EXIF content for an IFD
 * \param[in] tag EXIF tag to return
 * \return #ExifEntry of the tag, or NULL on error
 */
ExifEntry   *exif_content_get_entry    (ExifContent *content, ExifTag tag);

/*! Fix the IFD to bring it into specification. Call #exif_entry_fix on
 * each entry in this IFD to fix existing entries, create any new entries
 * that are mandatory in this IFD but do not yet exist, and remove any
 * entries that are not allowed in this IFD.
 *
 * \param[in,out] c EXIF content for an IFD
 */
void         exif_content_fix          (ExifContent *c);

alias void function(ExifEntry *, void *user_data) ExifContentForeachEntryFunc;

/*! Executes function on each EXIF tag in this IFD in turn.
 * The tags will not necessarily be visited in numerical order.
 *
 * \param[in,out] content IFD over which to iterate
 * \param[in] func function to call for each entry
 * \param[in] user_data data to pass into func on each call
 */
void         exif_content_foreach_entry (ExifContent *content,
					 ExifContentForeachEntryFunc func,
					 void *user_data);

/*! Return the IFD number in which the given #ExifContent is found.
 *
 * \param[in] c an #ExifContent*
 * \return IFD number, or #EXIF_IFD_COUNT on error
 */
ExifIfd exif_content_get_ifd (ExifContent *c);

/*! Return a textual representation of the EXIF data for a tag.
 *
 * \param[in] c #ExifContent* for an IFD
 * \param[in] t #ExifTag to return
 * \param[out] v char* buffer in which to store value
 * \param[in] m unsigned int length of the buffer v
 * \return the v pointer, or NULL on error
 */
const(char)* exif_content_get_value(ExifContent* c, ExifTag t, char* v, uint m)
{
    return (exif_content_get_entry(c,t) ?
            exif_entry_get_value(exif_content_get_entry (c,t),v,m) : null);
}

/*! Dump contents of the IFD to stdout.
 * This is intended for diagnostic purposes only.
 *
 * \param[in] content IFD data
 * \param[in] indent how many levels deep to indent the data
 */
void exif_content_dump  (ExifContent *content, uint indent);

/*! Set the log message object for this IFD.
 *
 * \param[in] content IFD
 * \param[in] log #ExifLog*
 */
void exif_content_log   (ExifContent *content, ExifLog *log);

