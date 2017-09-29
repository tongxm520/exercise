##google: mobile client keep session alive

We have developed a mobile application (Android & iOS) which has custom login with limited session expiry time (3 days). The session will expire after 3 days and we are showing Login page to re-login.
But we don't want to show login page to the user. What are the best approach to do that.

Approach 1:
In the server side, do not set the expiry date to the generated session. So that session will not expire until user logged out.

Approach 2:
In UI, save the username & password in permanent storage like sqlite & etc. When the session expired (after 3 days in my case), UI has to send hidden login call to get new session id. In this case we will not redirect to login page.

How other mobile apps keep the session Id's alive till user logout.
Please suggest me any other best approach apart from above 2 approaches.



You can use following approach to solve your issue, I have faced same issue and used same approach :

Server should send a extra RefreshToken with your sessionId. And server should have a different API to refresh your sessionId with that refreshToken.
So suppose you get “invalid token” error, then you need to follow following steps :

call RefreshToken API using saved RefreshToken.
Server should refresh that sessionID & reset expiryTime to 3 days and reply you.
Server should create new RefreshToken at their end only whenever you logOut/login again And when 3 days expires(means user haven’t used app for 3 days so he should be logged out).
So you should logout only when that RefreshToken expires.
you will get new sessionID and then use that for further requests & for that request on which you got that error.


If your are using Oauth2 for athentication, here is the common setup:

User logs in on mobile app
If the credentials are ok, the server returns the access token, a refresh token and the token's lifetime
The mobile app stores those values + current timestamp
On the server's side, a garbage collector is configured to clear expired tokens
Before making any api call, the mobile app checks if the token is about to expire (with the help of the stored values). If the token is about to expire, the app sends the refresh token which instructs the server to generate a new access token
If you want users to stay connected, the app can be configured to check the access token periodically and request a new one if it's stale


Case 1: Mobile app actively talking to server:
Session timeout stamp keeps bumping up and session stays alive.

Case 2: Mobile app active without any server communication (e.g. incoming phone call, moving between apps etc.):
Server session may or may not timeout.
If it times out, next query to server will fail auth and return an error.
App consumes this error and gracefully redirects to login screen with a message toast urging the user to login. (This happens in my banking app)

Case 3: User kills the app on device and relaunches it:
The app should store the token either in sqllite or shared preferences. (Always logged in apps take this approach)
Upon relaunch, app can query the server with the presistent token.
If session is alive, communication goes through and user can continue. If not, user goes to login screen as in Case 2.


Commonly, it can be achieved, in the SOA over HTTP world via:
- HTTP basic auth over HTTPS;
- Cookies and session management;
- Query Authentication with additional signature parameters.

##HTTP basic auth over HTTPS

This first solution, based on the standard HTTPS protocol, is used by most web services. It's easy to implement, available by default on all browsers, but has some known draw-backs, like the awful authentication window displayed on the Browser, which will persist (there is no LogOut-like feature here), some server-side additional CPU consumption, and the fact that the user-name and password are transmitted (over HTTPS) into the Server (it should be more secure to let the password stay only on the client side, during keyboard entry, and be stored as secure hash on the Server).

The supplied TSQLite3HttpClientWinHTTP and TSQLite3HttpClientWinINet clients classes are able to connect using HTTPS, and the THttpApiServer server class can send compatible content.

##Session via Cookies
To be honest, a session managed on the Server is not truly Stateless.
One possibility could be to maintain all data within the cookie content. And, by design, the cookie is handled on the Server side (Client in fact don’t even try to interpret this cookie data: it just hands it back to the server on each successive request). But this cookie data is application state data, so the client should manage it, not the server, in a pure Stateless world.

The cookie technique itself is HTTP-linked, so it's not truly RESTful, which should be protocol-independent. In our framework, since we don't provide HTTP-like headers within each request, we can not handle cookies natively, for all transmission protocol used. So we tried not to use the Cookie technique.

##Query Authentication

Query Authentication consists in signing each RESTful request via some additional parameters on the URI.
See this reference about this technique. 

It was defined as such in this article:
    All REST queries must be authenticated by signing the query parameters sorted in lower-case, alphabetical order using the private credential as the signing token. Signing should occur before URL encoding the query string.

For instance, here is a generic URI sample, extracted from the link above:
 GET /object?apiKey=Qwerty2010

should be transmitted as such:
 GET /object?timestamp=1261496500&apiKey=Qwerty2010&signature=abcdef0123456789

The string being signed is "/object?apikey=Qwerty2010×tamp=1261496500" and the signature is the SHA256 hash of that string using the private component of the API key.

This technique is perhaps the more compatible with a Stateless architecture, and can also been implemented with a light session management.

Server-side data caching is always available. In our framework, we cache the responses at the SQL level, not at the URI level (thanks to our optimized implementation of GetJSONObjectAsSQL, the URI to SQL conversion is very fast). So adding this extra parameter doesn't break the cache mechanism.


2. SQLite3 Framework authentication

Even if, theoretically speaking, Query Authentication sounds to be the better for implementing a truly RESTful architecture, our framework tries to implement a Client-Server design.

In practice, we may consider two way of using it:
- With no authentication nor user right management (for instance for local access of data);
- With per-user authentication and right management via using defined security groups, and a per-query authentication.

According to RESTful principle, handling per-session data is not to be implemented in such an Architecture. A minimal "session-like" feature was introduced only to handle user authentication with very low overhead on both Client and Server side. The main technique used for our security is therefore Query Authentication, i.e. a per-URL signature, over a light per-User session authentication.


##Per-User authentication

On the Server side, a dedicated RESTful Service, accessible via the ModelRoot/Auth URI is to be called to register an User, and create a session. On the Server side, two tables, implemented by TSQLAuthGroup and TSQLAuthUser will handle respectively per-group access rights, and user authentication.

If both AuthGroup and AuthUser are not available on the Server TSQLModel (i.e. if the aHandleUserAuthentication parameter was set to false for the TSQLRestServer. Create constructor), no authentication is performed. All tables will be accessible by any client. For security reasons, the ability to execute INSERT / UPDATE / DELETE SQL statement via a RESTful POST command is never allowed with remote connections: only SELECT can be executed via this command.

If authentication is enabled for the Client-Server process (i.e. if both AuthGroup and AuthUser are available in the Server TSQLModel, i.e. aHandleUserAuthentication=true), each REST request will expect an additional parameter, named session_signature, to every URL. Using the URL instead of cookies allows the signature process to work with all communication protocols, not only HTTP. 

This will implement both Query Authentication together with a group-oriented per-user right management.

##Session handling

A dedicated RESTful service, available from the ModelRoot/Auth URI, is to be used for user authentication, handling so called sessions.

Here are the typical steps to be followed in order to create a new user session:
- Client sends a GET ModelRoot/auth?UserName=... request to the remote server;
- Server answers with an hexadecimal nonce contents (valid for about 5 minutes);
- Client sends a GET ModelRoot/auth?UserName=...&PassWord=...&ClientNonce=... request to the remote server, in which ClientNonce is a random value used as Client nonce, and PassWord is computed from the log-on and password entered by the User, using both Server and Client nonce as salt;
- Server checks that the transmitted password is valid, i.e. that its matches the hashed password stored in its database and a time-valid Server nonce - if the value is not correct, authentication failed;
- On success, Server will create a new in-memory session (sessions are not stored in the database, for lighter and safer process) and returns the session number and a private key to be used during the session;
- On any further access to the Server, a &session_signature= parameter is added to the URL, and will be checked against the valid sessions in order to validate the request;
- When the Client is about to close (typically in TSQLRestClientURI. Destroy), the GET ModelRoot/auth?UserName=...&Session=... request is sent to the remote server, in order to explicitly close the corresponding session in the server memory (avoiding most re-play attacks);
- Each opened session has an internal TimeOut parameter (retrieved from the associated TSQLAuthGroup table content): after some time of inactivity, sessions are closed on the Server Side.

Note that with this design, it's up to the Client to react to an authentication error during, and ask for the User pseudo and password at any time. For multiple reasons (server restart, session timeout...) the session can be closed at any time by the Server.

##URI signature

Query Authentication is handled at the Client side in TSQLRestClientURI. SessionSign method, by computing the session_signature parameter for a given URL.

In order to enhance security, the session_signature parameter will contain, encoded as 3 hexadecimal 32 bit cardinals:
- The Session ID (to retrieve the private key used for the signature);
- A Client Time Stamp (in 256 ms resolution) which must be greater or equal than the previous time stamp received;
- The URI signature, using the session private key, the user hashed password, and the supplied Client Time Stamp as source for its crc32 hashing algorithm.

Such a classical 3 points signature will avoid most man-in-the-middle (MITM) or re-play attacks.

For better Server-side performance, the URI signature will use fast crc32 hashing method, and not the more secure (but much slower) SHA-256. Since our security model is not officially validated as a standard method (there is no standard for per URI authentication of RESTful applications), the better security will be handled by encrypting the whole transmission channel, using standard HTTPS with certificates signed by a trusted CA, validated for both client and server side. The security involved by using crc32 will be enough for most common use. Note that the password hashing and the session opening will use SHA-256, to enhance security with no performance penalty.

In our implementation, for better Server-side reaction, the session_signature parameter is appended at the end of the URI, and the URI parameters are not sorted alphabetically, as suggested by the reference article quoted above. This should not be a problem, either from a Delphi Client either from a AJAX / JavaScript client.




##REST API - Configuring a Session Pool
##jwt token expiration refresh



##Benefits of token-based authentication

There are several benefits to using such approach:
##Cross-domain / CORS(Cross-Origin Resource Sharing)
  Cookies and CORS don't mix well across different domains. A token-based approach allows you to make AJAX calls to any server, on any domain because you use an HTTP header to transmit the user information.

##Stateless
  Tokens are stateless. There is no need to keep a session store, since the token is a self-contained entity that stores all the user information in it.

##Decoupling
  You are no longer tied to a particular authentication scheme. Tokens may be generated anywhere, so the API can be called from anywhere with a single authenticated command rather than multiple authenticated calls.

##Mobile ready
  Cookies are a problem when it comes to storing user information on native mobile applications. Adopting a token-based approach simplifies this saving process significantly.

##CSRF (Cross Site Request Forgery)
  Because the application does not rely on cookies for authentication, it is invulnerable cross site request attacks.

##Performance
  In terms of server-side load, a network roundtrip (e.g. finding a session on database) is likely to take more time than calculating an HMACSHA256 code to validate a token and parsing its contents, making token-based authentication faster than the traditional alternative.

Read more at https://www.pluralsight.com/guides/ruby-ruby-on-rails/token-based-authentication-with-ruby-on-rails-5-api



#####################################################
I work at Auth0 and I was involved in the design of the refresh token feature.
It all depends on the type of application and here is our recommended approach.

##Web applications
A good pattern is to refresh the token before it expires.

Set the token expiration to one week and refresh the token every time the user open the web application and every one hour. If a user doesn't open the application for more than a week, they will have to login again and this is acceptable web application UX.

To refresh the token your API needs a new endpoint that receives a valid, not expired JWT and returns the same signed JWT with the new expiration field. Then the web application will store the token somewhere.

##Mobile/Native applications
##Most native applications do login once and only once.

The idea is that the refresh token never expires and it can be exchanged always for a valid JWT.
The problem with a token that never expires is that never means never. What do you do if you lose your phone? So, it needs to be identifiable by the user somehow and the application needs to provide a way to revoke access. We decided to use the device's name, e.g. "maryo's iPad". Then the user can go to the application and revoke access to "maryo's iPad".

Another approach is to revoke the refresh token on specific events. An interesting event is changing the password.

We believe that JWT is not useful for these use cases so we use a random generated string and we store it on our side.
#####################################################
Shared Preferences is better for things like settings or small amounts of data. Data stored in the Shared Preferences is stored in key-value pairs. This makes retrieving the data simpler, but there is not a really efficient way to query/search for a specific piece of data. The database is an implementation of SQLite.

tricky 棘手
awkward [ˈôkwərd] 尴尬
It gets tricky and awkward,that would be suck(bad)

if a user’s access token is compromised/leaked
如果用户的访问令牌被泄露

even if an attacker somehow compromises your access token
即使攻击者以某种方式<损害/窃取>您的访问令牌 compromise=>damage/ruin/injury

a ruined castle

Interruption, interception, modification and forgery [ˈfôrjəri]
中断、截获、修改和伪造

In the worst case scenario above
在上述最坏的情况下
scenario [səˈneriəu] scene/situation
progress bar 进度条
Token Revocation 令牌撤销
let’s discuss the odds of this happening
让我们来讨论这种情况的可能性
greatly reduce 大大的减少
latency 延迟
confidential clients 机密客户
the different grants available in OAuth2
OAuth2中提供的不同授权方式
it’s only a matter of time before it’s abandoned.

For these sorts of applications, there is very little risk storing an access token for a long period of time, as the service contains only low-value content that can’t really hurt a user much if leaked
对于这类应用程序，存储访问令牌很长一段时间的风险很小，因为服务只包含低价值的内容，如果泄漏不会真的伤害用户

https://stormpath.com/blog/manage-authentication-lifecycle-mobile

If you’re dealing with any form of sensitive data (money, banking data, etc.), don’t bother storing access tokens on the mobile device at all. When you authenticate the user and get an access token, just keep it in memory. When a users closes your app, your memory will be cleaned up, and the token will be gone. This will force users to log into your app every time they open it, but that’s a good thing.

##OAuth2

##$ curl -X POST -H 'Authorization: Basic dGVzdGNsaWVudDpzZWNyZXQ=' -d 'grant_type=password&username=test&password=test' localhost:3000/oauth/token

{
    "token_type":"bearer",
    "access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiVlx1MDAxNcKbwoNUwoonbFPCu8KhwrYiLCJpYXQiOjE0NDQyNjI1NDMsImV4cCI6MTQ0NDI2MjU2M30.MldruS1PvZaRZIJR4legQaauQ3_DYKxxP2rFnD37Ip4",
    "expires_in":20,
    "refresh_token":"fdb8fdbecf1d03ce5e6125c067733c0d51de209c"
}

##$ curl 'localhost:3000/secret?access_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiVlx1MDAxNcKbwoNUwoonbFPCu8KhwrYiLCJpYXQiOjE0NDQyNjI2MTEsImV4cCI6MTQ0NDI2MjYzMX0.KkHI8KkF4nmi9z6rAQu9uffJjiJuNnsMg1DC3CnmEV0'

{
    "code":401,
    "error":"invalid_token",
    "error_description":"The access token provided has expired."
}


##curl -X POST -H 'Authorization: Basic dGVzdGNsaWVudDpzZWNyZXQ=' -d 'refresh_token=fdb8fdbecf1d03ce5e6125c067733c0d51de209c&grant_type=refresh_token' localhost:3000/oauth/token

{
    "token_type":"bearer",
    "access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiVlx1MDAxNcKbwoNUwoonbFPCu8KhwrYiLCJpYXQiOjE0NDQyNjI4NjYsImV4cCI6MTQ0NDI2Mjg4Nn0.Dww7TC-d0teDAgsmKHw7bhF2THNichsE6rVJq9xu_2s",
    "expires_in":20,
    "refresh_token":"7fd15938c823cf58e78019bea2af142f9449696a"
}



##Don’t Forget About Push Notifications
消息推送

Apps that go quiet for long periods of time can be forgotten about and eventually deleted. That doesn’t mean you should SPAM users, but you should think about relevant push notifications that draw them back into your app. For example, Musx has a weekly push notification to encourage users to look at the top 10 songs for the weekend. They also send selective timely notifications based on concerts and other music-related events.

Push notifications today can be very tailored and customizable, which makes them even more relevant. You can target devices, platforms, users who have performed certain actions, and more. Even though pushes are not a “shiny new feature,” they absolutely should be incorporated into your engagement strategy. 

##Making Database and Storage Decisions
No matter what type of database you use, it's worth noting that entity IDs should be randomly generated UUIDs, not sequential. This helps secure resources by making IDs much harder to guess. When it comes to storing your data, you might be considering a traditional relational database like MySQL or MariaDB. Or maybe you prefer the scalability of a noSQL document database like MongoDB. Or perhaps you prefer the flexibility of a hybrid approach that something like PostgreSQL can offer with both relational or document storage support. Which database your project should use is really going to depend on your data. 

GET    /libraries?sortBy=name&isCurrentlyOpen=true&pageCount=10
GET    /books?queryTitle=Sherlock+Holmes&queryAuthor=Arthur+Conan+Doyle
GET    /bookClubs?genre=mystery


##JWT (JSON Web Token) automatic prolongation of expiration
##just changing the secret ensures that any tokens made with the old secret are now invalid

1. In my limited experience, it's definitely better to verify your tokens with a second system. Simply validating the signature just means that the token was generated with your secret. Storing any created tokens in some sort of DB (redis, memcache/sql/mongo, or some other storage) is a fantastic way of assuring that you only accept tokens that your server has created. In this scenario, even if your secret is leaked, it won't matter too much as any generated tokens won't be valid anyway. This is the approach I'm taking with my system - all generated tokens are stored in a DB (redis) and on each request, I verify that the token is in my DB before I accept it. This way tokens can be revoked(撤销) for any reason, such as tokens that were released into the wild somehow, user logout, password changes, secret changes, etc.

2. This is something I don't have much experience in and is something I'm still actively researching as I'm not a security professional. If you find any resources, feel free to post them here! Currently, I'm just using a private key that I load from disk, but obviously that is far from the best or most secure solution.


##My back-end is Laravel framwork with jwt-auth and front-end is mobile application with React Native.
When I call to API (back-end), I must refresh token every time or not?

It's not necessary to refresh the token every time but only when it's almost expiring/expired
You can't use an expired token. refresh it before use at its already been blacklisted
You can use the following to refresh the token

$token = JWTAuth::getToken();
$new_token = JWTAuth::refresh($token);

Hello, this is custom middleware that I use, maybe could help... When the token is expired, the refreshed token is added to the response headers. The app just needs to search if the response has this, if so, update the saved token.

public function handle($request, Closure $next){
    // caching the next action
    $response = $next($request);

    try
    {
        if (! $user = JWTAuth::parseToken()->authenticate() )
        {
            return ApiHelpers::ApiResponse(101, null);
        }
    }
    catch (TokenExpiredException $e)
    {
        // If the token is expired, then it will be refreshed and added to the headers
        try
        {
            $refreshed = JWTAuth::refresh(JWTAuth::getToken());
            $response->header('Authorization', 'Bearer ' . $refreshed);
        }
        catch (JWTException $e)
        {
            return ApiHelpers::ApiResponse(103, null);
        }
        $user = JWTAuth::setToken($refreshed)->toUser();
    }
    catch (JWTException $e)
    {
        return ApiHelpers::ApiResponse(101, null);
    }

    // Login the user instance for global usage
    Auth::login($user, false);
    return $response;
}

##Refreshing Expired Token Requires Decoding

Refresh tokens can be invalidated/expired in these cases

1. User revokes access to your application
2. The refresh token is used to obtain a new access token and new refresh token
3. The user goes through the Authorization process again and gets a new refresh token
(At any given time, there is only 1 valid refresh token.)

##Revoking All Tokens for a User

Users can sign out from all devices where they are currently signed in when you revoke all of the user's tokens by using the GlobalSignOut and AdminUserGlobalSignOut APIs. After the user has been signed out:

The user's refresh token cannot be used to get new tokens for the user.
The user's access token cannot be used against the user pools service.
The user must reauthenticate to get new tokens.


previous_access_at
current_access_at=Time.now
if(current_access_at - previous_access_at>=a week ) regenerate access_token
make judgement whether the access token is expired or expiring per access 
if close to expired regenerate access_token to return to client
change secret periodically



