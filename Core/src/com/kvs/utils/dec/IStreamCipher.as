/**
 * IStreamCipher
 * 
 * A "marker" interface for stream ciphers.
 * 
 */
package com.kvs.utils.dec {
	
	/**
	 * A marker to indicate how this cipher works.
	 * A stream cipher:
	 * - does not use initialization vector
	 * - keeps some internal state between calls to encrypt() and decrypt()
	 * 
	 */
	public interface IStreamCipher extends ICipher {
		
	}
}