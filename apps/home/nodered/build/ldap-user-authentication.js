
var LdapAuth = require('ldapauth-fork');
var LRU = require('lru-cache');

var opts = {};

/*
 * @param {Object} opts - Config options
 * @constructor
 */
function UserCache(opts) {
    this.opts = opts;
        
    if (typeof this.opts.enabled === 'undefined') this.opts.enabled = true;
    if (typeof this.opts.size === 'undefined')    this.opts.size = 100;
    if (typeof this.opts.maxAge === 'undefined')  this.opts.maxAge = 120;
    
    if (this.opts.enabled) {
        console.log("Init user cache");
        this.cache = new LRU({
            max: this.opts.size,
            maxAge: this.opts.maxAge * 1000
        });
    }
}

UserCache.prototype.set = function (username, user) {
    if (this.opts.enabled) {
        //console.log("Set in cache : " + username + " -> " + user);
        this.cache.set(username, user)
    }
}

UserCache.prototype.get = function (username) {
    if (this.opts.enabled) {
        var user = this.cache.get(username);
        //console.log("Get from cache : " + username + " -> " + user);
        return user;
    }
    return undefined;
}

var ldap = undefined;
var userCache = undefined;

module.exports = {
    type: "credentials",

    setup: function (options) {
        console.log("Setting up ldap-user-authentication");
        
        opts = options;
        //console.log(opts);

        ldap = new LdapAuth(opts.ldapOptions);
        ldap.on('error', function (err) {
            console.error('LdapAuth error : ', err);
        });
        
        userCache = new UserCache(opts.userCacheOptions)

        return this;
    },

    users: function (username) {
        //console.log("users : " + username);
        return new Promise(function (resolve) {
            var userFromCache = userCache.get(username);

            if(userFromCache != undefined) {
                resolve(userFromCache);
            } else {
                ldap._findUser(username, function (findErr, user) {
                    if (findErr) {
                        console.log("User search error : " + findErr);
                        resolve(null);
                    } else if (!user) {
                        console.log("User '" + username + "' not found");
                        resolve(null);
                    } else {
                        //console.log("User found : ");
                        //console.log(user);

                        var displayName = username;
                        if (opts.displayNameProperty && user[opts.displayNameProperty]) {
                            displayName = user[opts.displayNameProperty];
                        }
                        
                        var resolvedUser = { username: displayName, permissions: "*" };
                        userCache.set(username, resolvedUser);
                        resolve(resolvedUser);
                    }
                })
            }
        });
    },

    authenticate: function (username, password) {
        console.log("Authenticating '" + username + "'");
        return new Promise(function (resolve) {
            ldap.authenticate(username, password, function (err, user) {
                if (err) {
                    console.log("Authentication error : " + err);
                    resolve(null);
                } else {
                    console.log("User '" + username + "' authenticated");
                    //console.log(user);

                    var displayName = username;
                    if (opts.displayNameProperty && user[opts.displayNameProperty]) {
                        displayName = user[opts.displayNameProperty];
                    }

                    var resolvedUser = { username: displayName, permissions: "*" };
                    userCache.set(username, resolvedUser);
                    resolve(resolvedUser);
                }
            });
        });
    },

    default: function () {
        return new Promise(function (resolve) {
            if (opts !== undefined && opts.defaultToAnonymous) {
                resolve({ anonymous: true, permissions: "read" });
            } else {
                resolve(null);
            }
        });
    }
}
