/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * Create a signature for a path and query string using HmacSHA1.
 *
 * ```ts
 * const signature = createSignatureForPathAndQuery("/some-path?foo=bar", "secret");
 * ```
 * @param unsignedUrl The URL to sign.
 * @param secret The secret to use for signing.
 * @returns The signature of the signed url.
 */
export declare function createSignatureForPathAndQuery(pathAndQuery: string, secret: string): string;
/**
 * Create a signature for a Google Maps request [URL](https://developer.mozilla.org/en-US/docs/Web/API/URL) or url string.
 *
 * ```ts
 * const signature = createSignature("https://example.com/some-path?foo=bar", "secret");
 * ```
 *
 * @param unsignedUrl The URL to sign.
 * @param secret The secret to use for signing.
 * @returns The signature of the signed url.
 */
export declare function createSignature(unsignedUrl: URL | string, secret: string): string;
/**
 * Returns a new [URL](https://developer.mozilla.org/en-US/docs/Web/API/URL) having a signature parameter.
 *
 * ```ts
 * const signedUrl = signUrl("https://example.com/some-path?foo=bar", "secret");
 * signedUrl.href; // "https://example.com/some-path?foo=bar&signature=..."
 * ```
 *
 * @param unsignedUrl The URL to sign.
 * @param secret The secret to use for signing.
 * @returns The signature of the signed url.
 */
export declare function signUrl(unsignedUrl: URL | string, secret: string): URL;
