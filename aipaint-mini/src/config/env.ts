interface EnvironmentConfig {
  host: string;
}

const baseApi: { [key: string]: EnvironmentConfig } = {
  development: {
    host: "http://192.168.31.10:8080",
  },
  trial: {
    host: "https://xinlingkeji.cn",
  },
  release: {
    host: "https://yourdomian.com",
  },
  production: {
    host: "https://yourdomian.com",
  },
};

const mode =  "development";

export const baseUrl = baseApi[mode].host;
