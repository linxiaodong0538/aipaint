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

export const env = (process.env.NODE_ENV || "development") as keyof typeof baseApi;
export const baseUrl = baseApi[env]?.host || baseApi.development.host;
