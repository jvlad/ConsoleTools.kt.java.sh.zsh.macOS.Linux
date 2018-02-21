package test

import org.hamcrest.core.Is.`is`
import org.junit.Assert.*
import org.junit.Test
import main.utils.containsMACAddress
import main.utils.findMACAddressSubstring

/**
 * Created by zvlades on 9/18/17.
 */
class MACAddressUtilsTest {
    @Test
    fun shouldNotDetectMACAddress() {
        val withoutMACAddress = ";lfkg fgs;fdjgaf:q5:af:45:af:34    kgge"
        assertThat(containsMACAddress(withoutMACAddress), `is`(false))
    }

    @Test
    fun shouldDetectMACAddress() {
        val withMACAddress = ";lfkg fgs;fdjgaf:a5:af:45:af:34 fdlkshjgf"
        assertThat(containsMACAddress(withMACAddress), `is`(true))
    }

    @Test
    fun shouldFindMACAddressSubstring() {
        val withMACAddress = ";lfkg fgs;fdjgaf:a5:AF:45:af:34 fdlkshjgf"
        assertThat(findMACAddressSubstring(withMACAddress), `is`("af:a5:AF:45:af:34"))
    }

}