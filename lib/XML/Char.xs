#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"
#include "Char.h"


MODULE = XML::Char		PACKAGE = XML::Char		

int
_valid_xml_string(string)
    SV* string;
    
    PREINIT:
        STRLEN len;
        U8 * bytes;
        int in_range;
        int range_index;
        
        STRLEN ret_len;
        UV     uniuv;
    CODE:
        bytes  = (U8*)SvPV(string, len);
        if (!is_utf8_string(bytes, len)) {
            // warn("no utf8\n");
            
            RETVAL = 0;
        }
        else {
            // by default return true (ex. empty string)
            RETVAL = 1;
            
            // loop through all UTF-8 characters and make sure they are in allowed ranges
            while (len > 0) {
                // get unicode character value
                uniuv = utf8_to_uvuni(bytes, &ret_len);
                // warn("code: 0x%X len: %d\n", uniuv, ret_len);
                bytes += ret_len;
                len   -= ret_len;
                
                // loop through allowed ranges and check if the character is in any of them
                range_index = 0;
                in_range = 0;
                while (xml_ranges_from[range_index] != 0) {
                    // rangers are sorted so if the unicode value is smaller than current range_from then it is not in any range
                    if (uniuv < xml_ranges_from[range_index]) {
                        break;
                    }
                    // if the unicode value fall in this range it's valid
                    if ((uniuv >= xml_ranges_from[range_index]) && (uniuv <= xml_ranges_to[range_index])) {
                        // in the range
                        in_range = 1;
                        break;
                    }
                    range_index++;
                }
                
                // if the current character is not in allowed ranges return false
                if (!in_range) {
                    RETVAL = 0;
                    break;
                }
            }
        }
        
    OUTPUT:
        RETVAL
