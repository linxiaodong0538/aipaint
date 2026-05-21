interface EnvironmentConfig {
  host: string;
}

const baseApi: { [key: string]: EnvironmentConfig } = {
  development: {
    host: "http://192.168.124.32:8080",
  },
  trial: {
    host: "https://yourdomian.com",
  },
  release: {
    host: "https://yourdomian.com",
  },
  production: {
    host: "https://yourdomian.com",
  },
};

const mode = __APP_ENV__ || "development";

export const env = (mode in baseApi ? mode : "development") as keyof typeof baseApi;
export const baseUrl = __API_BASE_URL__ || baseApi[env].host;
