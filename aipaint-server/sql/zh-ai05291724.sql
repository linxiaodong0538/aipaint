/*
 Navicat Premium Data Transfer

 Source Server         : test
 Source Server Type    : MySQL
 Source Server Version : 80035 (8.0.35)
 Source Host           : localhost:3306
 Source Schema         : zh-ai

 Target Server Type    : MySQL
 Target Server Version : 80035 (8.0.35)
 File Encoding         : 65001

 Date: 29/05/2026 17:23:55
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ai_credit_batch
-- ----------------------------
DROP TABLE IF EXISTS `ai_credit_batch`;
CREATE TABLE `ai_credit_batch`  (
  `batch_id` bigint NOT NULL AUTO_INCREMENT COMMENT '积分批次ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `source_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '来源类型',
  `source_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '来源ID',
  `total_amount` int NOT NULL COMMENT '发放积分',
  `remaining_amount` int NOT NULL COMMENT '剩余积分',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '过期时间，空表示长期有效',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`batch_id`) USING BTREE,
  UNIQUE INDEX `uk_ai_credit_batch_source`(`user_id` ASC, `source_type` ASC, `source_id` ASC) USING BTREE,
  INDEX `idx_ai_credit_batch_user_expire`(`user_id` ASC, `expire_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户积分批次表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_credit_batch
-- ----------------------------
INSERT INTO `ai_credit_batch` VALUES (1, 103, 'SIGNIN', '2026-05-25', 5, 0, '2026-06-01 10:29:27', '每日签到奖励，7天有效', '2026-05-25 10:29:27', '2026-05-25 10:29:39');
INSERT INTO `ai_credit_batch` VALUES (2, 103, 'NEW_USER_GIFT', '103', 100, 0, '2026-06-01 15:49:59', '新人礼包，7天有效', '2026-05-25 15:49:59', '2026-05-26 01:50:24');
INSERT INTO `ai_credit_batch` VALUES (3, 103, 'GENERATION_REFUND', '38', 5, 0, '2026-06-01 15:50:19', '生成失败退款，7天有效', '2026-05-25 15:50:19', '2026-05-26 01:50:24');
INSERT INTO `ai_credit_batch` VALUES (4, 103, 'GENERATION_REFUND', '40', 5, 0, '2026-06-01 16:09:24', '生成失败退款，7天有效', '2026-05-25 16:09:24', '2026-05-26 01:50:24');
INSERT INTO `ai_credit_batch` VALUES (5, 103, 'GENERATION_REFUND', '47', 18, 0, '2026-06-02 01:41:03', '生成失败退款，7天有效', '2026-05-26 01:41:02', '2026-05-26 01:53:07');
INSERT INTO `ai_credit_batch` VALUES (6, 103, 'GENERATION_REFUND', '48', 18, 0, '2026-06-02 01:47:57', '生成失败退款，7天有效', '2026-05-26 01:47:57', '2026-05-26 02:04:39');
INSERT INTO `ai_credit_batch` VALUES (7, 103, 'GENERATION_REFUND', '49', 15, 0, '2026-06-02 01:49:11', '生成失败退款，7天有效', '2026-05-26 01:49:10', '2026-05-26 19:20:46');
INSERT INTO `ai_credit_batch` VALUES (8, 103, 'SIGNIN', '2026-05-26', 5, 0, '2026-06-02 19:06:03', '每日签到奖励，7天有效', '2026-05-26 19:06:03', '2026-05-26 19:20:46');
INSERT INTO `ai_credit_batch` VALUES (9, 103, 'MANUAL_TEST', 'manual_test_20260526191754', 1000, 599, NULL, '测试手动加积分', '2026-05-26 19:17:54', '2026-05-28 17:10:10');
INSERT INTO `ai_credit_batch` VALUES (10, 103, 'GENERATION_REFUND', '53', 30, 0, '2026-06-02 19:20:46', '生成失败退款，7天有效', '2026-05-26 19:20:46', '2026-05-26 19:21:44');
INSERT INTO `ai_credit_batch` VALUES (11, 103, 'GENERATION_REFUND', '54', 30, 0, '2026-06-02 19:24:06', '生成失败退款，7天有效', '2026-05-26 19:24:05', '2026-05-26 22:17:29');
INSERT INTO `ai_credit_batch` VALUES (12, 103, 'GENERATION_REFUND', '55', 6, 0, '2026-06-02 22:11:27', '生成失败退款，7天有效', '2026-05-26 22:11:27', '2026-05-26 22:17:29');
INSERT INTO `ai_credit_batch` VALUES (13, 103, 'GENERATION_REFUND', '56', 12, 0, '2026-06-02 22:13:38', '生成失败退款，7天有效', '2026-05-26 22:13:37', '2026-05-26 22:17:39');
INSERT INTO `ai_credit_batch` VALUES (14, 103, 'GENERATION_REFUND', '57', 12, 0, '2026-06-02 22:17:30', '生成失败退款，7天有效', '2026-05-26 22:17:30', '2026-05-26 22:18:05');
INSERT INTO `ai_credit_batch` VALUES (15, 103, 'GENERATION_REFUND', '58', 12, 0, '2026-06-02 22:17:39', '生成失败退款，7天有效', '2026-05-26 22:17:39', '2026-05-26 22:20:31');
INSERT INTO `ai_credit_batch` VALUES (16, 103, 'GENERATION_REFUND', '59', 12, 0, '2026-06-02 22:18:05', '生成失败退款，7天有效', '2026-05-26 22:18:05', '2026-05-26 22:21:02');
INSERT INTO `ai_credit_batch` VALUES (17, 103, 'GENERATION_REFUND', '60', 12, 0, '2026-06-02 22:20:32', '生成失败退款，7天有效', '2026-05-26 22:20:31', '2026-05-26 22:21:08');
INSERT INTO `ai_credit_batch` VALUES (18, 103, 'GENERATION_REFUND', '61', 12, 0, '2026-06-02 22:21:03', '生成失败退款，7天有效', '2026-05-26 22:21:02', '2026-05-26 22:21:13');
INSERT INTO `ai_credit_batch` VALUES (19, 103, 'GENERATION_REFUND', '62', 12, 0, '2026-06-02 22:21:08', '生成失败退款，7天有效', '2026-05-26 22:21:08', '2026-05-26 22:21:17');
INSERT INTO `ai_credit_batch` VALUES (20, 103, 'GENERATION_REFUND', '63', 12, 0, '2026-06-02 22:21:14', '生成失败退款，7天有效', '2026-05-26 22:21:14', '2026-05-26 22:21:41');
INSERT INTO `ai_credit_batch` VALUES (21, 103, 'GENERATION_REFUND', '64', 12, 0, '2026-06-02 22:21:18', '生成失败退款，7天有效', '2026-05-26 22:21:17', '2026-05-26 22:36:07');
INSERT INTO `ai_credit_batch` VALUES (22, 103, 'GENERATION_REFUND', '65', 12, 0, '2026-06-02 22:23:01', '生成失败退款，7天有效', '2026-05-26 22:23:01', '2026-05-26 22:36:22');
INSERT INTO `ai_credit_batch` VALUES (23, 103, 'GENERATION_REFUND', '66', 12, 0, '2026-06-02 22:36:08', '生成失败退款，7天有效', '2026-05-26 22:36:07', '2026-05-26 22:45:05');
INSERT INTO `ai_credit_batch` VALUES (24, 103, 'GENERATION_REFUND', '67', 12, 0, '2026-06-02 22:36:23', '生成失败退款，7天有效', '2026-05-26 22:36:22', '2026-05-26 22:47:54');
INSERT INTO `ai_credit_batch` VALUES (25, 103, 'GENERATION_REFUND', '68', 12, 0, '2026-06-02 22:45:06', '生成失败退款，7天有效', '2026-05-26 22:45:06', '2026-05-26 22:55:51');
INSERT INTO `ai_credit_batch` VALUES (26, 103, 'GENERATION_REFUND', '69', 12, 0, '2026-06-02 22:47:55', '生成失败退款，7天有效', '2026-05-26 22:47:55', '2026-05-26 22:59:30');
INSERT INTO `ai_credit_batch` VALUES (27, 103, 'GENERATION_REFUND', '70', 12, 0, '2026-06-02 22:55:54', '生成失败退款，7天有效', '2026-05-26 22:55:54', '2026-05-26 23:45:18');
INSERT INTO `ai_credit_batch` VALUES (28, 103, 'GENERATION_REFUND', '75', 6, 0, '2026-06-03 00:13:46', '生成失败退款，7天有效', '2026-05-27 00:13:45', '2026-05-27 00:14:13');
INSERT INTO `ai_credit_batch` VALUES (29, 103, 'GENERATION_REFUND', '76', 6, 0, '2026-06-03 00:14:31', '生成失败退款，7天有效', '2026-05-27 00:14:30', '2026-05-27 00:14:54');
INSERT INTO `ai_credit_batch` VALUES (30, 103, 'SIGNIN', '2026-05-27', 10, 0, '2026-06-03 16:34:11', '每日签到奖励，7天有效', '2026-05-27 16:34:10', '2026-05-28 09:35:37');
INSERT INTO `ai_credit_batch` VALUES (31, 103, 'SIGNIN', '2026-05-28', 10, 0, '2026-06-04 10:00:42', '每日签到奖励，7天有效', '2026-05-28 10:00:41', '2026-05-28 10:05:08');

-- ----------------------------
-- Table structure for ai_credit_record
-- ----------------------------
DROP TABLE IF EXISTS `ai_credit_record`;
CREATE TABLE `ai_credit_record`  (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '积分流水ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `change_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '变动类型',
  `amount` int NOT NULL COMMENT '变动积分，正数增加负数扣减',
  `balance_after` int NOT NULL COMMENT '变动后可用余额',
  `related_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联类型',
  `related_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联ID',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`record_id`) USING BTREE,
  INDEX `idx_ai_credit_record_user_time`(`user_id` ASC, `create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户积分流水表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_credit_record
-- ----------------------------
INSERT INTO `ai_credit_record` VALUES (1, 103, 'SIGNIN', 5, 5, 'SIGNIN', '2026-05-25', '每日签到奖励，7天有效', '2026-05-25 10:29:27');
INSERT INTO `ai_credit_record` VALUES (2, 103, 'GENERATION_CONSUME', -5, 0, 'GENERATION', '31', '图片生成扣费', '2026-05-25 10:29:39');
INSERT INTO `ai_credit_record` VALUES (3, 103, 'NEW_USER_GIFT', 100, 100, 'NEW_USER_GIFT', '103', '新人礼包，7天有效', '2026-05-25 15:49:59');
INSERT INTO `ai_credit_record` VALUES (4, 103, 'GENERATION_CONSUME', -5, 95, 'GENERATION', '38', '图片生成扣费', '2026-05-25 15:50:18');
INSERT INTO `ai_credit_record` VALUES (5, 103, 'GENERATION_REFUND', 5, 100, 'GENERATION_REFUND', '38', '生成失败退款，7天有效', '2026-05-25 15:50:19');
INSERT INTO `ai_credit_record` VALUES (6, 103, 'GENERATION_CONSUME', -5, 95, 'GENERATION', '39', '图片生成扣费', '2026-05-25 16:01:11');
INSERT INTO `ai_credit_record` VALUES (7, 103, 'GENERATION_CONSUME', -5, 90, 'GENERATION', '40', '图片生成扣费', '2026-05-25 16:08:23');
INSERT INTO `ai_credit_record` VALUES (8, 103, 'GENERATION_REFUND', 5, 95, 'GENERATION_REFUND', '40', '生成失败退款，7天有效', '2026-05-25 16:09:24');
INSERT INTO `ai_credit_record` VALUES (9, 103, 'GENERATION_CONSUME', -5, 90, 'GENERATION', '41', '图片生成扣费', '2026-05-25 16:15:30');
INSERT INTO `ai_credit_record` VALUES (10, 103, 'GENERATION_CONSUME', -5, 85, 'GENERATION', '42', '图片生成扣费', '2026-05-25 16:28:36');
INSERT INTO `ai_credit_record` VALUES (11, 103, 'GENERATION_CONSUME', -5, 80, 'GENERATION', '43', '图片生成扣费', '2026-05-25 16:39:19');
INSERT INTO `ai_credit_record` VALUES (12, 103, 'GENERATION_CONSUME', -5, 75, 'GENERATION', '44', '图片生成扣费', '2026-05-25 17:10:51');
INSERT INTO `ai_credit_record` VALUES (13, 103, 'GENERATION_CONSUME', -5, 70, 'GENERATION', '45', '图片生成扣费', '2026-05-25 17:17:06');
INSERT INTO `ai_credit_record` VALUES (14, 103, 'GENERATION_CONSUME', -6, 64, 'GENERATION', '46', '图片生成扣费', '2026-05-26 01:37:54');
INSERT INTO `ai_credit_record` VALUES (15, 103, 'GENERATION_CONSUME', -18, 46, 'GENERATION', '47', '图片生成扣费', '2026-05-26 01:40:59');
INSERT INTO `ai_credit_record` VALUES (16, 103, 'GENERATION_REFUND', 18, 64, 'GENERATION_REFUND', '47', '生成失败退款，7天有效', '2026-05-26 01:41:02');
INSERT INTO `ai_credit_record` VALUES (17, 103, 'GENERATION_CONSUME', -18, 46, 'GENERATION', '48', '图片生成扣费', '2026-05-26 01:47:42');
INSERT INTO `ai_credit_record` VALUES (18, 103, 'GENERATION_REFUND', 18, 64, 'GENERATION_REFUND', '48', '生成失败退款，7天有效', '2026-05-26 01:47:57');
INSERT INTO `ai_credit_record` VALUES (19, 103, 'GENERATION_CONSUME', -15, 49, 'GENERATION', '49', '图片生成扣费', '2026-05-26 01:49:07');
INSERT INTO `ai_credit_record` VALUES (20, 103, 'GENERATION_REFUND', 15, 64, 'GENERATION_REFUND', '49', '生成失败退款，7天有效', '2026-05-26 01:49:10');
INSERT INTO `ai_credit_record` VALUES (21, 103, 'GENERATION_CONSUME', -18, 46, 'GENERATION', '50', '图片生成扣费', '2026-05-26 01:50:24');
INSERT INTO `ai_credit_record` VALUES (22, 103, 'GENERATION_CONSUME', -18, 28, 'GENERATION', '51', '图片生成扣费', '2026-05-26 01:53:07');
INSERT INTO `ai_credit_record` VALUES (23, 103, 'GENERATION_CONSUME', -15, 13, 'GENERATION', '52', '图片生成扣费', '2026-05-26 02:04:39');
INSERT INTO `ai_credit_record` VALUES (24, 103, 'SIGNIN', 5, 18, 'SIGNIN', '2026-05-26', '每日签到奖励，7天有效', '2026-05-26 19:06:03');
INSERT INTO `ai_credit_record` VALUES (25, 103, 'MANUAL_TEST', 1000, 1018, 'MANUAL_TEST', 'manual_test_20260526191754', '测试手动加积分', '2026-05-26 19:17:54');
INSERT INTO `ai_credit_record` VALUES (26, 103, 'GENERATION_CONSUME', -30, 988, 'GENERATION', '53', '图片生成扣费', '2026-05-26 19:20:46');
INSERT INTO `ai_credit_record` VALUES (27, 103, 'GENERATION_REFUND', 30, 1018, 'GENERATION_REFUND', '53', '生成失败退款，7天有效', '2026-05-26 19:20:46');
INSERT INTO `ai_credit_record` VALUES (28, 103, 'GENERATION_CONSUME', -30, 988, 'GENERATION', '54', '图片生成扣费', '2026-05-26 19:21:44');
INSERT INTO `ai_credit_record` VALUES (29, 103, 'GENERATION_REFUND', 30, 1018, 'GENERATION_REFUND', '54', '生成失败退款，7天有效', '2026-05-26 19:24:05');
INSERT INTO `ai_credit_record` VALUES (30, 103, 'GENERATION_CONSUME', -12, 1006, 'GENERATION', '55', '图片生成扣费', '2026-05-26 22:10:03');
INSERT INTO `ai_credit_record` VALUES (31, 103, 'GENERATION_REFUND', 6, 1012, 'GENERATION_REFUND', '55', '生成失败退款，7天有效', '2026-05-26 22:11:27');
INSERT INTO `ai_credit_record` VALUES (32, 103, 'GENERATION_CONSUME', -12, 1000, 'GENERATION', '56', '图片生成扣费', '2026-05-26 22:13:36');
INSERT INTO `ai_credit_record` VALUES (33, 103, 'GENERATION_REFUND', 12, 1012, 'GENERATION_REFUND', '56', '生成失败退款，7天有效', '2026-05-26 22:13:37');
INSERT INTO `ai_credit_record` VALUES (34, 103, 'GENERATION_CONSUME', -12, 1000, 'GENERATION', '57', '图片生成扣费', '2026-05-26 22:17:29');
INSERT INTO `ai_credit_record` VALUES (35, 103, 'GENERATION_REFUND', 12, 1012, 'GENERATION_REFUND', '57', '生成失败退款，7天有效', '2026-05-26 22:17:30');
INSERT INTO `ai_credit_record` VALUES (36, 103, 'GENERATION_CONSUME', -12, 1000, 'GENERATION', '58', '图片生成扣费', '2026-05-26 22:17:39');
INSERT INTO `ai_credit_record` VALUES (37, 103, 'GENERATION_REFUND', 12, 1012, 'GENERATION_REFUND', '58', '生成失败退款，7天有效', '2026-05-26 22:17:39');
INSERT INTO `ai_credit_record` VALUES (38, 103, 'GENERATION_CONSUME', -12, 1000, 'GENERATION', '59', '图片生成扣费', '2026-05-26 22:18:05');
INSERT INTO `ai_credit_record` VALUES (39, 103, 'GENERATION_REFUND', 12, 1012, 'GENERATION_REFUND', '59', '生成失败退款，7天有效', '2026-05-26 22:18:05');
INSERT INTO `ai_credit_record` VALUES (40, 103, 'GENERATION_CONSUME', -12, 1000, 'GENERATION', '60', '图片生成扣费', '2026-05-26 22:20:31');
INSERT INTO `ai_credit_record` VALUES (41, 103, 'GENERATION_REFUND', 12, 1012, 'GENERATION_REFUND', '60', '生成失败退款，7天有效', '2026-05-26 22:20:31');
INSERT INTO `ai_credit_record` VALUES (42, 103, 'GENERATION_CONSUME', -12, 1000, 'GENERATION', '61', '图片生成扣费', '2026-05-26 22:21:02');
INSERT INTO `ai_credit_record` VALUES (43, 103, 'GENERATION_REFUND', 12, 1012, 'GENERATION_REFUND', '61', '生成失败退款，7天有效', '2026-05-26 22:21:02');
INSERT INTO `ai_credit_record` VALUES (44, 103, 'GENERATION_CONSUME', -12, 1000, 'GENERATION', '62', '图片生成扣费', '2026-05-26 22:21:08');
INSERT INTO `ai_credit_record` VALUES (45, 103, 'GENERATION_REFUND', 12, 1012, 'GENERATION_REFUND', '62', '生成失败退款，7天有效', '2026-05-26 22:21:08');
INSERT INTO `ai_credit_record` VALUES (46, 103, 'GENERATION_CONSUME', -12, 1000, 'GENERATION', '63', '图片生成扣费', '2026-05-26 22:21:14');
INSERT INTO `ai_credit_record` VALUES (47, 103, 'GENERATION_REFUND', 12, 1012, 'GENERATION_REFUND', '63', '生成失败退款，7天有效', '2026-05-26 22:21:14');
INSERT INTO `ai_credit_record` VALUES (48, 103, 'GENERATION_CONSUME', -12, 1000, 'GENERATION', '64', '图片生成扣费', '2026-05-26 22:21:17');
INSERT INTO `ai_credit_record` VALUES (49, 103, 'GENERATION_REFUND', 12, 1012, 'GENERATION_REFUND', '64', '生成失败退款，7天有效', '2026-05-26 22:21:17');
INSERT INTO `ai_credit_record` VALUES (50, 103, 'GENERATION_CONSUME', -12, 1000, 'GENERATION', '65', '图片生成扣费', '2026-05-26 22:21:41');
INSERT INTO `ai_credit_record` VALUES (51, 103, 'GENERATION_REFUND', 12, 1012, 'GENERATION_REFUND', '65', '生成失败退款，7天有效', '2026-05-26 22:23:01');
INSERT INTO `ai_credit_record` VALUES (52, 103, 'GENERATION_CONSUME', -12, 1000, 'GENERATION', '66', '图片生成扣费', '2026-05-26 22:36:07');
INSERT INTO `ai_credit_record` VALUES (53, 103, 'GENERATION_REFUND', 12, 1012, 'GENERATION_REFUND', '66', '生成失败退款，7天有效', '2026-05-26 22:36:07');
INSERT INTO `ai_credit_record` VALUES (54, 103, 'GENERATION_CONSUME', -12, 1000, 'GENERATION', '67', '图片生成扣费', '2026-05-26 22:36:22');
INSERT INTO `ai_credit_record` VALUES (55, 103, 'GENERATION_REFUND', 12, 1012, 'GENERATION_REFUND', '67', '生成失败退款，7天有效', '2026-05-26 22:36:22');
INSERT INTO `ai_credit_record` VALUES (56, 103, 'GENERATION_CONSUME', -12, 1000, 'GENERATION', '68', '图片生成扣费', '2026-05-26 22:45:05');
INSERT INTO `ai_credit_record` VALUES (57, 103, 'GENERATION_REFUND', 12, 1012, 'GENERATION_REFUND', '68', '生成失败退款，7天有效', '2026-05-26 22:45:06');
INSERT INTO `ai_credit_record` VALUES (58, 103, 'GENERATION_CONSUME', -12, 1000, 'GENERATION', '69', '图片生成扣费', '2026-05-26 22:47:54');
INSERT INTO `ai_credit_record` VALUES (59, 103, 'GENERATION_REFUND', 12, 1012, 'GENERATION_REFUND', '69', '生成失败退款，7天有效', '2026-05-26 22:47:55');
INSERT INTO `ai_credit_record` VALUES (60, 103, 'GENERATION_CONSUME', -12, 1000, 'GENERATION', '70', '图片生成扣费', '2026-05-26 22:55:51');
INSERT INTO `ai_credit_record` VALUES (61, 103, 'GENERATION_REFUND', 12, 1012, 'GENERATION_REFUND', '70', '生成失败退款，7天有效', '2026-05-26 22:55:54');
INSERT INTO `ai_credit_record` VALUES (62, 103, 'GENERATION_CONSUME', -12, 1000, 'GENERATION', '71', '图片生成扣费', '2026-05-26 22:59:30');
INSERT INTO `ai_credit_record` VALUES (63, 103, 'GENERATION_CONSUME', -12, 988, 'GENERATION', '72', '图片生成扣费', '2026-05-26 23:45:18');
INSERT INTO `ai_credit_record` VALUES (64, 103, 'GENERATION_CONSUME', -12, 976, 'GENERATION', '73', '图片生成扣费', '2026-05-26 23:54:04');
INSERT INTO `ai_credit_record` VALUES (65, 103, 'GENERATION_CONSUME', -6, 970, 'GENERATION', '74', '图片生成扣费', '2026-05-27 00:12:32');
INSERT INTO `ai_credit_record` VALUES (66, 103, 'GENERATION_CONSUME', -6, 964, 'GENERATION', '75', '图片生成扣费', '2026-05-27 00:13:25');
INSERT INTO `ai_credit_record` VALUES (67, 103, 'GENERATION_REFUND', 6, 970, 'GENERATION_REFUND', '75', '生成失败退款，7天有效', '2026-05-27 00:13:45');
INSERT INTO `ai_credit_record` VALUES (68, 103, 'GENERATION_CONSUME', -6, 964, 'GENERATION', '76', '图片生成扣费', '2026-05-27 00:14:13');
INSERT INTO `ai_credit_record` VALUES (69, 103, 'GENERATION_REFUND', 6, 970, 'GENERATION_REFUND', '76', '生成失败退款，7天有效', '2026-05-27 00:14:30');
INSERT INTO `ai_credit_record` VALUES (70, 103, 'GENERATION_CONSUME', -6, 964, 'GENERATION', '77', '图片生成扣费', '2026-05-27 00:14:54');
INSERT INTO `ai_credit_record` VALUES (71, 103, 'GENERATION_CONSUME', -6, 958, 'GENERATION', '78', '图片生成扣费', '2026-05-27 00:32:15');
INSERT INTO `ai_credit_record` VALUES (72, 103, 'GENERATION_CONSUME', -6, 952, 'GENERATION', '79', '图片生成扣费', '2026-05-27 00:34:21');
INSERT INTO `ai_credit_record` VALUES (73, 103, 'GENERATION_CONSUME', -20, 932, 'GENERATION', '80', '图片生成扣费', '2026-05-27 11:56:32');
INSERT INTO `ai_credit_record` VALUES (74, 103, 'GENERATION_CONSUME', -24, 908, 'GENERATION', '81', '图片生成扣费', '2026-05-27 11:59:07');
INSERT INTO `ai_credit_record` VALUES (75, 103, 'GENERATION_CONSUME', -15, 893, 'GENERATION', '82', '图片生成扣费', '2026-05-27 13:45:25');
INSERT INTO `ai_credit_record` VALUES (76, 103, 'GENERATION_CONSUME', -12, 881, 'GENERATION', '83', '图片生成扣费', '2026-05-27 14:33:24');
INSERT INTO `ai_credit_record` VALUES (77, 103, 'GENERATION_CONSUME', -15, 866, 'GENERATION', '84', '图片生成扣费', '2026-05-27 14:34:08');
INSERT INTO `ai_credit_record` VALUES (78, 103, 'SIGNIN', 10, 876, 'SIGNIN', '2026-05-27', '每日签到奖励，7天有效', '2026-05-27 16:34:10');
INSERT INTO `ai_credit_record` VALUES (79, 103, 'GENERATION_CONSUME', -18, 858, 'GENERATION', '85', '图片生成扣费', '2026-05-28 09:35:37');
INSERT INTO `ai_credit_record` VALUES (80, 103, 'GENERATION_CONSUME', -15, 843, 'GENERATION', '86', '图片生成扣费', '2026-05-28 09:52:11');
INSERT INTO `ai_credit_record` VALUES (81, 103, 'SIGNIN', 10, 853, 'SIGNIN', '2026-05-28', '每日签到奖励，7天有效', '2026-05-28 10:00:41');
INSERT INTO `ai_credit_record` VALUES (82, 103, 'GENERATION_CONSUME', -15, 838, 'GENERATION', '87', '图片生成扣费', '2026-05-28 10:05:08');
INSERT INTO `ai_credit_record` VALUES (83, 103, 'GENERATION_CONSUME', -15, 823, 'GENERATION', '88', '图片生成扣费', '2026-05-28 10:06:28');
INSERT INTO `ai_credit_record` VALUES (84, 103, 'GENERATION_CONSUME', -15, 808, 'GENERATION', '89', '图片生成扣费', '2026-05-28 10:22:48');
INSERT INTO `ai_credit_record` VALUES (85, 103, 'GENERATION_CONSUME', -6, 802, 'GENERATION', '90', '图片生成扣费', '2026-05-28 10:24:42');
INSERT INTO `ai_credit_record` VALUES (86, 103, 'GENERATION_CONSUME', -15, 787, 'GENERATION', '91', '图片生成扣费', '2026-05-28 10:27:55');
INSERT INTO `ai_credit_record` VALUES (87, 103, 'GENERATION_CONSUME', -15, 772, 'GENERATION', '92', '图片生成扣费', '2026-05-28 10:40:19');
INSERT INTO `ai_credit_record` VALUES (88, 103, 'GENERATION_CONSUME', -15, 757, 'GENERATION', '93', '图片生成扣费', '2026-05-28 10:42:41');
INSERT INTO `ai_credit_record` VALUES (89, 103, 'GENERATION_CONSUME', -15, 742, 'GENERATION', '94', '图片生成扣费', '2026-05-28 10:52:37');
INSERT INTO `ai_credit_record` VALUES (90, 103, 'GENERATION_CONSUME', -15, 727, 'GENERATION', '95', '图片生成扣费', '2026-05-28 10:56:21');
INSERT INTO `ai_credit_record` VALUES (91, 103, 'GENERATION_CONSUME', -15, 712, 'GENERATION', '96', '图片生成扣费', '2026-05-28 10:56:46');
INSERT INTO `ai_credit_record` VALUES (92, 103, 'GENERATION_CONSUME', -15, 697, 'GENERATION', '97', '图片生成扣费', '2026-05-28 11:07:46');
INSERT INTO `ai_credit_record` VALUES (93, 103, 'GENERATION_CONSUME', -15, 682, 'GENERATION', '98', '图片生成扣费', '2026-05-28 11:28:18');
INSERT INTO `ai_credit_record` VALUES (94, 103, 'GENERATION_CONSUME', -15, 667, 'GENERATION', '99', '图片生成扣费', '2026-05-28 11:29:05');
INSERT INTO `ai_credit_record` VALUES (95, 103, 'GENERATION_CONSUME', -15, 652, 'GENERATION', '100', '图片生成扣费', '2026-05-28 11:29:29');
INSERT INTO `ai_credit_record` VALUES (96, 103, 'GENERATION_CONSUME', -15, 637, 'GENERATION', '101', '图片生成扣费', '2026-05-28 11:30:41');
INSERT INTO `ai_credit_record` VALUES (97, 103, 'GENERATION_CONSUME', -5, 632, 'GENERATION', '102', '图片生成扣费', '2026-05-28 11:35:25');
INSERT INTO `ai_credit_record` VALUES (98, 103, 'GENERATION_CONSUME', -10, 622, 'GENERATION', '103', '图片生成扣费', '2026-05-28 14:38:54');
INSERT INTO `ai_credit_record` VALUES (99, 103, 'GENERATION_CONSUME', -12, 610, 'GENERATION', '104', '图片生成扣费', '2026-05-28 15:05:19');
INSERT INTO `ai_credit_record` VALUES (100, 103, 'GENERATION_CONSUME', -6, 604, 'GENERATION', '105', '图片生成扣费', '2026-05-28 17:08:06');
INSERT INTO `ai_credit_record` VALUES (101, 103, 'GENERATION_CONSUME', -5, 599, 'GENERATION', '106', '图片生成扣费', '2026-05-28 17:10:10');

-- ----------------------------
-- Table structure for ai_generation_task
-- ----------------------------
DROP TABLE IF EXISTS `ai_generation_task`;
CREATE TABLE `ai_generation_task`  (
  `task_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `provider_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '提供方编码',
  `prompt` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '提示词',
  `model` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模型',
  `quality` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '质量',
  `ratio` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '画幅比例',
  `size` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '图片尺寸',
  `resolution` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '2k' COMMENT '分辨率档位',
  `image_urls` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '参考图URL，逗号分隔',
  `image_count` int NOT NULL DEFAULT 1 COMMENT '生成张数',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务状态',
  `progress` int NOT NULL DEFAULT 0 COMMENT '任务进度',
  `result_image_url` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '结果图片地址',
  `preview_image_url` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '预览图片地址',
  `error_message` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '错误信息',
  `credit_cost` int NULL DEFAULT 0 COMMENT '消耗积分',
  `run_start_time` datetime NULL DEFAULT NULL COMMENT '开始运行时间',
  `finish_time` datetime NULL DEFAULT NULL COMMENT '完成时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`task_id`) USING BTREE,
  INDEX `idx_ai_generation_task_user_status`(`user_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_ai_generation_task_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 107 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI图片生成任务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_generation_task
-- ----------------------------
INSERT INTO `ai_generation_task` VALUES (1, 103, '', '可乐', 'gpt-image-2', 'low', '1:1', '256x256', '2k', NULL, 1, 'failed', 0, NULL, NULL, '图片生成失败：{\n  \"error\": {\n    \"message\": \"Invalid size \'256x256\'. Requested resolution is below the current minimum pixel budget.\",\n    \"type\": \"image_generation_user_error\",\n    \"param\": \"tools\",\n    \"code\": \"invalid_value\"\n  }\n}\n', 2, NULL, '2026-05-20 20:39:55', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-20 20:39:52', '', '2026-05-20 20:39:54');
INSERT INTO `ai_generation_task` VALUES (2, 103, '', '可乐', 'gpt-image-1', 'low', '1:1', '1024x1024', '2k', NULL, 1, 'deleted', 100, '/profile/upload/2026/05/20/a3151327-5af1-4f92-9683-e7302920640b.png', '/profile/upload/2026/05/20/a3151327-5af1-4f92-9683-e7302920640b.png', '用户删除', 2, NULL, '2026-05-20 20:44:50', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-20 20:44:28', '', '2026-05-28 08:05:33');
INSERT INTO `ai_generation_task` VALUES (3, 103, '', 'This full-body regional mascot onesie features a rounded, oversized mascot silhouette made from soft, comfortable fabric. The massive mascot head is highly expressive with simple embroidered eyes and a bright smile. The outfit is vibrant and colorful, complemented by oversized gloves and rounded mascot shoes. The puffy, padded jumpsuit has rounded proportions and is decorated with accessories like scarves and ribbons. It creates a friendly, festive atmosphere with fine stitching and mascot seams, showcasing a cute promotional character aesthetic. Bright, fresh colors and a whimsical mascot design. A face-out regional mascot pajama style designed to match the image background.', 'gpt-image-1', 'low', '1:1', '1024x1024', '2k', NULL, 1, 'failed', 0, NULL, NULL, '图片生成失败：EOF reached while reading', 2, NULL, '2026-05-20 21:19:13', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-20 21:18:12', '', '2026-05-20 21:19:12');
INSERT INTO `ai_generation_task` VALUES (4, 103, '', 'This full-body regional mascot onesie features a rounded, oversized mascot silhouette made from soft, comfortable fabric. The massive mascot head is highly expressive with simple embroidered eyes and a bright smile. The outfit is vibrant and colorful, complemented by oversized gloves and rounded mascot shoes. The puffy, padded jumpsuit has rounded proportions and is decorated with accessories like scarves and ribbons. It creates a friendly, festive atmosphere with fine stitching and mascot seams, showcasing a cute promotional character aesthetic. Bright, fresh colors and a whimsical mascot design. A face-out regional mascot pajama style designed to match the image background.', 'gpt-image-1', 'low', '1:1', '1024x1024', '2k', NULL, 1, 'failed', 0, NULL, NULL, '图片生成失败：EOF reached while reading', 2, NULL, '2026-05-20 21:25:12', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-20 21:24:11', '', '2026-05-20 21:25:11');
INSERT INTO `ai_generation_task` VALUES (5, 103, '', 'This full-body regional mascot onesie features a rounded, oversized mascot silhouette made from soft, comfortable fabric. The massive mascot head is highly expressive with simple embroidered eyes and a bright smile. The outfit is vibrant and colorful, complemented by oversized gloves and rounded mascot shoes. The puffy, padded jumpsuit has rounded proportions and is decorated with accessories like scarves and ribbons. It creates a friendly, festive atmosphere with fine stitching and mascot seams, showcasing a cute promotional character aesthetic. Bright, fresh colors and a whimsical mascot design. A face-out regional mascot pajama style designed to match the image background.', 'gpt-image-2', 'low', '1:1', '1024x1024', '2k', NULL, 1, 'deleted', 100, '/profile/upload/2026/05/20/5d3a0010-d8fd-4014-a73a-7185482c4851.png', '/profile/upload/2026/05/20/5d3a0010-d8fd-4014-a73a-7185482c4851.png', '用户删除', 2, NULL, '2026-05-20 21:27:09', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-20 21:26:15', '', '2026-05-28 08:05:35');
INSERT INTO `ai_generation_task` VALUES (6, 103, '', 'Limited edition sneaker release poster, sneakers levitating in mid-air, flame special effects background', 'gpt-image-2', 'low', '3:4', '1024x1536', '2k', NULL, 1, 'failed', 0, NULL, NULL, '图片生成失败：EOF reached while reading', 2, NULL, '2026-05-21 01:18:15', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-21 01:17:14', '', '2026-05-21 01:18:15');
INSERT INTO `ai_generation_task` VALUES (7, 103, '', 'Limited edition sneaker release poster, sneakers levitating in mid-air, flame special effects background', 'gpt-image-2', 'low', '3:4', '1024x1536', '2k', NULL, 1, 'success', 0, '/profile/upload/2026/05/21/67f46a2d-f0e3-45e8-83db-32018e8aaa16.png', '/profile/upload/2026/05/21/67f46a2d-f0e3-45e8-83db-32018e8aaa16.png', NULL, 2, NULL, '2026-05-21 01:20:10', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-21 01:19:16', '', '2026-05-21 01:20:09');
INSERT INTO `ai_generation_task` VALUES (8, 103, 'primary', 'XXX endorsing XXX car poster', 'gpt-image-2', 'low', '1:1', '1024x1024', '2k', NULL, 1, 'failed', 0, NULL, NULL, '图片生成失败：EOF reached while reading', 2, NULL, '2026-05-22 01:32:16', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-22 01:30:15', '', '2026-05-22 01:32:16');
INSERT INTO `ai_generation_task` VALUES (9, 103, 'primary', '{\n  \"image_generation_prompt\": {\n    \"subject\": {\n      \"identity\": \"Young female mechanic\",\n      \"hair\": \"Long, dark brown hair, worn loose with a slight wave, draped over right shoulder\",\n      \"facial_features\": \"Soft facial features, slight smile, looking directly at camera\",\n      \"skin_details\": \"Visible grease and oil smudges on face (cheeks, forehead, chin) indicating manual labor\",\n      \"makeup\": \"Natural look, accentuated by the grime\"\n    },\n    \"apparel_and_accessories\": {\n      \"clothing\": \"Navy blue mechanic coveralls (jumpsuit), unzipped at the top revealing a grey scoop-neck tank top underneath\",\n      \"jewelry\": \"Layered thin silver necklaces, one featuring a cross pendant, small hoop earrings\",\n      \"hands\": \"Manicured nails (black polish) contrasting with dirty, grease-covered hands\"\n    },\n    \"pose_and_action\": {\n      \"posture\": \"Leaning forward over an open car engine bay\",\n      \"action\": \"Holding a silver wrench in both hands, resting arms on the car frame\",\n      \"expression\": \"Friendly, confident, candid engagement with the viewer\"\n    },\n    \"environment\": {\n      \"setting\": \"Auto repair shop / garage interior\",\n      \"background_elements\": [\n        \"Blue hydraulic car lift post on the left\",\n        \"White pegboard wall with organized hanging wrenches and tools\",\n        \"Workbench with miscellaneous automotive fluids and parts\",\n        \"Car engine bay details in foreground (hoses, engine cover, radiator cap)\"\n      ]\n    },\n    \"technical_specifications\": {\n      \"quality\": \"4K Ultra HD, hyper-realistic\",\n      \"style\": \"Cinematic portrait, candid photography style\",\n      \"lighting\": \"Bright, even workshop lighting, soft shadows\",\n      \"focus\": \"Sharp focus on subject&#x27;s face and hands, slightly shallow depth of field blurring the background tools\",\n      \"texture_details\": \"High fidelity textures on denim coveralls, metallic tools, and oily skin\"\n    }\n  }\n}', 'gpt-image-2', 'low', '1:1', '1024x1024', '2k', NULL, 1, 'failed', 0, NULL, NULL, '图片生成失败：EOF reached while reading', 2, NULL, '2026-05-22 01:40:33', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-22 01:38:31', '', '2026-05-22 01:40:32');
INSERT INTO `ai_generation_task` VALUES (10, 103, 'primary', '苹果', 'gpt-image-2', 'low', '1:1', '1024x1024', '2k', NULL, 1, 'deleted', 100, '/profile/upload/2026/05/22/9d42122a-d00e-496e-80bd-d787cb9ea1d1.png', '/profile/upload/2026/05/22/9d42122a-d00e-496e-80bd-d787cb9ea1d1.png', '用户删除', 2, NULL, '2026-05-22 01:46:30', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-22 01:46:11', '', '2026-05-28 08:05:36');
INSERT INTO `ai_generation_task` VALUES (11, 103, 'primary', '西瓜', 'gpt-image-2', 'low', '1:1', '1024x1024', '2k', NULL, 1, 'deleted', 100, '/profile/upload/2026/05/22/f0b2b5a5-c653-4973-bdc1-70f8fc846a0f.png', '/profile/upload/2026/05/22/f0b2b5a5-c653-4973-bdc1-70f8fc846a0f.png', '用户删除', 2, NULL, '2026-05-22 01:48:22', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-22 01:47:51', '', '2026-05-28 08:05:38');
INSERT INTO `ai_generation_task` VALUES (12, 103, 'primary', '赛博朋克风格的霓虹街道、阳光明媚的沙滩', 'gpt-image-2', 'low', '1:1', '1024x1024', '2k', NULL, 1, 'failed', 0, NULL, NULL, '图片生成失败：EOF reached while reading', 2, NULL, '2026-05-22 01:54:19', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-22 01:52:17', '', '2026-05-22 01:54:18');
INSERT INTO `ai_generation_task` VALUES (13, 103, 'primary', 'Please turn the attached image into a monochrome line drawing.', 'gpt-image-2', 'medium', '1:1', '1024x1024', '2k', NULL, 1, 'failed', 0, NULL, NULL, '图片生成失败：EOF reached while reading', 4, NULL, '2026-05-22 02:05:59', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-22 02:04:58', '', '2026-05-22 02:05:59');
INSERT INTO `ai_generation_task` VALUES (14, 103, 'primary', 'A matte black sports car tears through a dense autumn forest, leaves exploding into the air behind it in a vibrant storm of gold, orange, and red. The camera chases tightly from just behind, weaving through trees at impossible speeds, dipping low with every sharp drift. Sunlight filters through the canopy in golden shafts, briefly lighting up the windshield like a spark of fire. The road is narrow, winding, slick with fallen leaves. Tires screech, birds scatter. The car blurs briefly with motion, then snaps into focus as it bursts around corners. Shot in ultra-realistic, high-frame-rate slow motion with rich cinematic depth and hyper-saturated fall colors.', 'gpt-image-2', 'medium', '1:1', '1024x1024', '2k', NULL, 1, 'success', 0, '/profile/upload/2026/05/22/ec1f5a0b-ce91-4362-86e3-42e64cba5308.png', '/profile/upload/2026/05/22/ec1f5a0b-ce91-4362-86e3-42e64cba5308.png', NULL, 4, NULL, '2026-05-22 02:09:30', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-22 02:08:29', '', '2026-05-22 02:09:29');
INSERT INTO `ai_generation_task` VALUES (15, 103, 'primary', '一辆哑光黑色跑车在浓密的秋季森林中疾驰而过，身后落叶在空中飞舞，形成一场金色、橙色和红色的绚丽风暴。镜头紧紧追赶，穿梭于树林之间，每一次急落都低垂。阳光透过遮阳篷，金色光束洒进来，短暂地照亮挡风玻璃，如同火花。道路狭窄、曲折，落叶湿滑。轮胎尖叫，鸟儿四散逃窜。车身短暂地模糊了一下，然后在转弯时突然变得清晰。采用超写实、高帧率慢动作拍摄，拥有丰富的电影级深度和极度饱和的秋色', 'gpt-image-2', 'high', '1:1', '1:1', '1K', '', 1, 'failed', 100, NULL, NULL, '图片生成失败：{\"error\":{\"message\":\"Invalid image size\",\"type\":\"invalid_request_error\",\"code\":null,\"status\":400}}', 6, NULL, '2026-05-23 00:48:53', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-23 00:48:52', '', '2026-05-23 00:48:53');
INSERT INTO `ai_generation_task` VALUES (16, 103, 'primary', '一辆哑光黑色跑车在浓密的秋季森林中疾驰而过，身后落叶在空中飞舞，形成一场金色、橙色和红色的绚丽风暴。镜头紧紧追赶，穿梭于树林之间，每一次急落都低垂。阳光透过遮阳篷，金色光束洒进来，短暂地照亮挡风玻璃，如同火花。道路狭窄、曲折，落叶湿滑。轮胎尖叫，鸟儿四散逃窜。车身短暂地模糊了一下，然后在转弯时突然变得清晰。采用超写实、高帧率慢动作拍摄，拥有丰富的电影级深度和极度饱和的秋色', 'gpt-image-2', 'high', '1:1', '1:1', '1K', '', 1, 'failed', 100, NULL, NULL, '图片生成失败：{\"error\":{\"message\":\"Invalid image size\",\"type\":\"invalid_request_error\",\"code\":null,\"status\":400}}', 6, NULL, '2026-05-23 00:52:16', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-23 00:52:15', '', '2026-05-23 00:52:16');
INSERT INTO `ai_generation_task` VALUES (17, 103, 'primary', '一辆哑光黑色跑车在浓密的秋季森林中疾驰而过，身后落叶在空中飞舞，形成一场金色、橙色和红色的绚丽风暴。镜头紧紧追赶，穿梭于树林之间，每一次急落都低垂。阳光透过遮阳篷，金色光束洒进来，短暂地照亮挡风玻璃，如同火花。道路狭窄、曲折，落叶湿滑。轮胎尖叫，鸟儿四散逃窜。车身短暂地模糊了一下，然后在转弯时突然变得清晰。采用超写实、高帧率慢动作拍摄，拥有丰富的电影级深度和极度饱和的秋色', 'gpt-image-2', 'high', '1:1', '1024x1024', '1K', '', 1, 'failed', 100, NULL, NULL, '图片生成失败：HTTP/1.1 header parser received no bytes', 6, NULL, '2026-05-23 01:01:12', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-23 01:00:08', '', '2026-05-23 01:01:12');
INSERT INTO `ai_generation_task` VALUES (18, 103, 'primary', '一辆哑光黑色跑车在浓密的秋季森林中疾驰而过，身后落叶在空中飞舞，形成一场金色、橙色和红色的绚丽风暴。镜头紧紧追赶，穿梭于树林之间，每一次急落都低垂。阳光透过遮阳篷，金色光束洒进来，短暂地照亮挡风玻璃，如同火花。道路狭窄、曲折，落叶湿滑。轮胎尖叫，鸟儿四散逃窜。车身短暂地模糊了一下，然后在转弯时突然变得清晰。采用超写实、高帧率慢动作拍摄，拥有丰富的电影级深度和极度饱和的秋色', 'gpt-image-2', 'high', '1:1', '1024x1024', '1K', '', 1, 'failed', 100, NULL, NULL, '主通道失败：图片生成失败：HTTP/1.1 header parser received no bytes；备用通道失败：图片生成失败：HTTP/1.1 header parser received no bytes', 6, NULL, '2026-05-23 01:13:04', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-23 01:11:03', '', '2026-05-23 01:13:03');
INSERT INTO `ai_generation_task` VALUES (19, 103, 'primary', 'Generate a high-definition vertical 2:3 image with the theme \'Architectural Miniature Blueprint\'. The scene features a modern architectural design manuscript filled with Chinese floor plans, sections, elevations, structural details, dimensions, and construction notes. A highly realistic 3D miniature model of an ancient Chinese building is \'rising\' from the paper. The main building occupies 65%–75% of the frame, emphasizing height and volume through a low-angle 3/4 top-down perspective with realistic shadows. The building should be in mid-construction (70%–85% complete). Incorporate miniature construction details: tiny workers, scaffolding, wooden frames, ramps, pulleys, beams, stones, tiles, material piles, and carts. The style is a mix of a professional architectural concept board and a museum-grade miniature. The color palette includes off-white, light gray, pale blue, and charcoal line work. All text must be in Chinese, with a main title \'[Building Name]\' and subtitle \'Diagram of the Architectural Construction Process\'. Use soft neutral lighting for a clean, sophisticated, and modern look. Avoid parchment textures, vintage aesthetics, cluttered desks, or modern machinery. The final result should look like an ancient structure being physically built out of modern blueprints, blending architectural precision with miniature artistry.', 'gpt-image-2', 'high', '1:1', '1024x1024', '1K', '', 1, 'failed', 100, NULL, NULL, '主通道失败：图片生成失败：restricted header name: \"Connection\"；备用通道失败：图片生成失败：restricted header name: \"Connection\"', 6, NULL, '2026-05-23 01:31:08', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-23 01:31:07', '', '2026-05-23 01:31:07');
INSERT INTO `ai_generation_task` VALUES (20, 103, 'primary', 'Generate a high-definition vertical 2:3 image with the theme \'Architectural Miniature Blueprint\'. The scene features a modern architectural design manuscript filled with Chinese floor plans, sections, elevations, structural details, dimensions, and construction notes. A highly realistic 3D miniature model of an ancient Chinese building is \'rising\' from the paper. The main building occupies 65%–75% of the frame, emphasizing height and volume through a low-angle 3/4 top-down perspective with realistic shadows. The building should be in mid-construction (70%–85% complete). Incorporate miniature construction details: tiny workers, scaffolding, wooden frames, ramps, pulleys, beams, stones, tiles, material piles, and carts. The style is a mix of a professional architectural concept board and a museum-grade miniature. The color palette includes off-white, light gray, pale blue, and charcoal line work. All text must be in Chinese, with a main title \'[Building Name]\' and subtitle \'Diagram of the Architectural Construction Process\'. Use soft neutral lighting for a clean, sophisticated, and modern look. Avoid parchment textures, vintage aesthetics, cluttered desks, or modern machinery. The final result should look like an ancient structure being physically built out of modern blueprints, blending architectural precision with miniature artistry.', 'gpt-image-2', 'high', '1:1', '1024x1024', '1K', '', 1, 'failed', 100, NULL, NULL, '图片生成响应异常，请稍后到作品中查看', 6, NULL, '2026-05-23 01:33:33', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-23 01:32:32', '', '2026-05-23 01:33:33');
INSERT INTO `ai_generation_task` VALUES (21, 103, 'primary', 'A hyper-realistic photo of an ordinary refrigerator opened to reveal a miniature, vibrant city inside. The city is illuminated with tiny street lights, skyscrapers, parks, and moving cars, all nestled within the fridge shelves. Cool mist seeps out around the edges, mixing with the refrigerator’s cold interior light. The outside environment looks like a normal modern kitchen, but the surreal scene inside the fridge feels magical and astonishing. Focus on detailed textures: glossy city buildings, condensation on the fridge walls, realistic lighting and reflections.', 'gpt-image-2', 'high', '1:1', '2048x2048', '2K', '', 1, 'failed', 100, NULL, NULL, '图片生成响应异常，本地未收到生成结果，请重试', 6, NULL, '2026-05-23 01:55:38', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-23 01:45:54', '', '2026-05-23 01:55:38');
INSERT INTO `ai_generation_task` VALUES (22, 103, 'primary', '一张超写实的普通冰箱照片打开，露出里面一个微型、充满活力的城市。城市被微小的路灯、摩天大楼、公园和行驶中的汽车照亮，这些都藏在冰箱的架子里。凉爽的雾气从边缘渗出，与冰箱冷冷的室内灯光混合。外面的环境看起来像普通的现代厨房，但冰箱里那超现实的场景却显得神奇且令人惊叹。重点关注细节纹理：光亮的城市建筑、冰箱墙上的凝结水、逼真的光影和反射。', 'gpt-image-2', 'high', '1:1', '1024x1024', '1K', '', 1, 'failed', 100, NULL, NULL, '图片生成响应异常，本地未收到生成结果，请重试', 6, NULL, '2026-05-23 01:59:18', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-23 01:58:17', '', '2026-05-23 01:59:17');
INSERT INTO `ai_generation_task` VALUES (23, 103, 'primary', '通用“模块化木块浮雕系统”提示（身份锁定——严格）：使用上传的图片作为主题和唯一的身份参考。身份锁定——严格（不可妥协）保持面部结构、比例和特征位置的精确。不要改变眼睛、鼻子、嘴巴或轮廓。保持表达和可识别性。姿势与构图——锁定 保持原始角度、构图和透视。没有旋转、镜像或摄像机变化。风格变换——木版浮雕（硬版） 将整个图像转化为密集的雕刻木结构：用相互交织的木块、杆和雕刻段重建所有形态（面部、头发、服装、背景）。使用矩形横梁、圆木棒、切片横截面和叠木板混合使用。保持紧密的填料密度，间隙尽量减少（没有空的平坦区域）。材料系统——木材（关键） 所有元素必须是真实的木材，具有明显的纹理、环形和自然变化。纹理方向必须遵循每个作品的形态（不能随机纹理）。包括切割的末端、结节和细微的瑕疵。表面处理：哑光到半哑光的天然木质（无塑料，无光泽）。深度与结构——硬浮雕 构建多层深度堆叠（前景、中景、背景块）。棋子必须重叠、相互锁扣，并像雕刻墙一样进出。通过深度过渡来保持面部拓扑，而不是平滑着色。面部与头发集成——统一系统（关键）面部和头发必须由同一木块系统构成。头发以细长的雕刻分段形式自然流动。面部特征通过精准排列较小的块状结构和轮廓来定义。材料之间没有分隔——一切都是木头。 光照——形态揭示 使用定向光强调深度、边缘和纹理。阴影必须强化图层分离和结构清晰度。负面提示（严格）：禁止光滑的皮肤，禁止涂料覆盖，禁止平面阴影。禁止使用金属、塑料或非木材材料。没有松散的抽象形状或柔和的混合。没有面部结构或透视的扭曲。没有缝隙或空地——保持密集的施工。', 'gpt-image-2', 'high', '1:1', '1024x1024', '1K', '', 1, 'failed', 100, NULL, NULL, '图片下载失败：400', 6, NULL, '2026-05-23 02:07:21', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-23 02:04:21', '', '2026-05-23 02:07:21');
INSERT INTO `ai_generation_task` VALUES (24, 103, 'primary', '一个可爱的拟人化[主体]三重视角：前左、前、后。站立姿态，身材丰满，表情丰富，穿着[服装/风格]。3D 皮克斯风格的卡通吉祥物，细节丰富，阴影柔和，背景干净', 'gpt-image-2', 'low', '1:1', '1024x1024', '1K', '', 1, 'deleted', 100, '/profile/upload/2026/05/23/3518d957-f35c-4877-8c46-530101ffb02b.jpg', '/profile/upload/2026/05/23/3518d957-f35c-4877-8c46-530101ffb02b.jpg', '用户删除', 2, NULL, '2026-05-23 02:11:34', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-23 02:10:31', '', '2026-05-28 08:06:04');
INSERT INTO `ai_generation_task` VALUES (25, 103, 'primary', '您是一位专属 IP 贴纸设计师。请根据用户上传的图片，生成竖版 Q 版（Q 版）贴纸展示海报。核心要求：所有表情必须基于上传的图片；请勿制作通用贴纸。保留核心识别特征：轮廓、颜色、面部特征、发型/毛发、服装、配饰、耳朵、尾巴和标志性物品。请勿替换面部、物种、服装、配色方案或发型。如果是人物，请将其转换为可爱的 Q 版；如果是宠物，请保留标记和毛发；如果是物品，请在保留原有形状的前提下进行拟人化。贴纸套装必须以官方贴纸包的形式呈现，风格统一，角色设计一致。自动判断合适的性格类型（治愈、搞笑、工作、傲娇、酷帅、亲密、宠物或中性），并据此选择 9-12 个表情。每个贴纸必须包含：相同的主题、清晰的动作、鲜明的情绪、中文短语、白色贴纸边框和柔和的阴影。海报布局：顶部是可爱的标题，中间是大幅主角图片，周围环绕着 9-12 张小贴纸。背景：温暖简约（米白色、浅黄色、浅粉色等），点缀一些小装饰元素，例如爱心或星星。视觉风格：Q 版，圆润，治愈系，贴纸风格，高清，简洁布局。文字要求：中文文字必须清晰易读，无变形或错误。', 'gpt-image-2', 'low', '1:1', '1024x1024', '1K', '', 1, 'deleted', 100, 'https://gpt2image.superapi.buzz/api/storage/generations/lpCySTtezG9YHYM9NDyx3iK3IGlIE7Oz/_pPzbRexe-m5cwWbuUHWOjzik0s-ONBE.jpg', 'https://gpt2image.superapi.buzz/api/storage/generations/lpCySTtezG9YHYM9NDyx3iK3IGlIE7Oz/_pPzbRexe-m5cwWbuUHWOjzik0s-ONBE.jpg', '用户删除', 2, NULL, '2026-05-23 10:55:13', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-23 10:51:55', '', '2026-05-28 10:41:20');
INSERT INTO `ai_generation_task` VALUES (26, 103, 'primary', '1', 'gpt-image-2', 'high', '1:1', '2048x2048', '2K', '', 1, 'success', 100, 'https://gpt2image.superapi.buzz/api/storage/generations/lpCySTtezG9YHYM9NDyx3iK3IGlIE7Oz/KbpHRhS5eUF5v4s3YW8mD4sEIt6LAtZN.jpg', 'https://gpt2image.superapi.buzz/api/storage/generations/lpCySTtezG9YHYM9NDyx3iK3IGlIE7Oz/KbpHRhS5eUF5v4s3YW8mD4sEIt6LAtZN.jpg', NULL, 6, NULL, '2026-05-23 11:00:40', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-23 11:00:13', '', '2026-05-23 11:00:40');
INSERT INTO `ai_generation_task` VALUES (27, 103, 'primary', '2', 'gpt-image-2', 'low', '1:1', '1024x1024', '1K', '', 2, 'success', 100, '/profile/upload/2026/05/23/b3fc1d3e-1703-4e3d-bd30-e05647eb2c58.jpg', '/profile/upload/2026/05/23/b3fc1d3e-1703-4e3d-bd30-e05647eb2c58.jpg', NULL, 4, NULL, '2026-05-23 11:01:31', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-23 11:01:16', '', '2026-05-23 11:01:30');
INSERT INTO `ai_generation_task` VALUES (28, 103, 'primary', '3', 'gpt-image-2', 'low', '1:1', '1024x1024', '1K', '', 2, 'success', 100, '/profile/upload/2026/05/23/a220ddef-15d3-4add-b822-1150909affe7.jpg', '/profile/upload/2026/05/23/a220ddef-15d3-4add-b822-1150909affe7.jpg', NULL, 4, NULL, '2026-05-23 11:44:43', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-23 11:43:54', '', '2026-05-23 11:44:42');
INSERT INTO `ai_generation_task` VALUES (29, 103, 'primary', '4', 'gpt-image-2', 'low', '1:1', '1024x1024', '1K', '', 2, 'failed', 100, NULL, NULL, '主通道失败：生成结果数量不足：期望 2 张，实际 1 张；备用通道失败：图片生成失败：invalid URI scheme data', 4, NULL, '2026-05-23 11:58:38', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-23 11:57:59', '', '2026-05-23 11:58:37');
INSERT INTO `ai_generation_task` VALUES (30, 103, 'primary', '5', 'gpt-image-2', 'low', '1:1', '1024x1024', '1K', '', 2, 'success', 100, '/profile/upload/2026/05/23/03a95ae9-b045-417f-a8f3-3b46218acf26.jpg,/profile/upload/2026/05/23/18d04cc7-f9a3-449c-803b-fa1082dfac2c.jpg', '/profile/upload/2026/05/23/03a95ae9-b045-417f-a8f3-3b46218acf26.jpg,/profile/upload/2026/05/23/18d04cc7-f9a3-449c-803b-fa1082dfac2c.jpg', NULL, 4, NULL, '2026-05-23 13:33:12', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-23 13:32:30', '', '2026-05-23 13:33:12');
INSERT INTO `ai_generation_task` VALUES (31, 103, 'primary', 'Limited edition sneaker release poster, sneakers levitating in mid-air, flame special effects background', 'gpt-image-2', 'low', '1:1', '1024x1024', '1K', '', 1, 'deleted', 100, 'https://gpt2image.superapi.buzz/api/storage/generations/lpCySTtezG9YHYM9NDyx3iK3IGlIE7Oz/T_jlhQiei2HVe3UilcD0Jp9SrRa-ZauT.jpg', 'https://gpt2image.superapi.buzz/api/storage/generations/lpCySTtezG9YHYM9NDyx3iK3IGlIE7Oz/T_jlhQiei2HVe3UilcD0Jp9SrRa-ZauT.jpg', '用户删除', 5, NULL, '2026-05-25 10:30:38', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-25 10:29:39', '', '2026-05-28 10:41:18');
INSERT INTO `ai_generation_task` VALUES (32, 103, 'superapi', 'Design a 4:5 sports art poster for \'ATHELETE_NAME\' using realistic, soft, thick painted motion fields, player’s leap translated into directional brush energy, a vertical ascension composition, and an emotional goal of disciplined transcendence and cold precision. \n\nCONCEPT: player is not just depicted—he is constructed out of force. His iconic jump is visualized as a surge of realistic paint strokes based on PLAYER’s team jersey colors, rising like a controlled explosion, turning athletic elevation into a visual language of upward pressure, discipline, and momentum. The poster captures the instant where physical power becomes abstract motion. \n\nSUBJECT: player rendered as a dominant semi-abstract figure emerging from layered, soft, freshly painted strokes rather than a fully literal photograph. His body is partially defined—recognizable facial structure and torso clarity—but limbs dissolve into sweeping, thick paint gestures, especially around the legs and arms, emphasizing lift and motion. The figure is angled upward, as if still climbing, occupying the central vertical axis but never fully contained. \n\nCOMPOSITION: A vertical ascension layout where the bottom third is dense with heavy, soft, realistic brush strokes, gradually opening into lighter, more fluid white space toward the top. The eye path starts at thick, grounded painted textures and travels upward through flowing lines and fragmented form into player’s mid-air presence. Negative space at the top acts as a zone of calm highlight contrast against the dense painted energy below. The background behaves like a freshly painted atmosphere, not a flat field, with directional strokes reinforcing upward motion.\n\nTYPOGRAPHY: Headline: \'RISE WITHOUT LIMIT\' set in a condensed athletic sans-serif brushed text, vertically stretched on the left side, and partially masked by soft paint strokes, as if emerging through layers. The baseline subtly curves upward, following the motion of the brushwork. \nSubhead: \'Discipline', 'gpt-image-2', 'medium', '1:1', '1024x1024', '1K', '', 1, 'failed', 100, NULL, NULL, '积分不足，请先充值', 5, NULL, NULL, 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-25 15:44:35', '', '2026-05-25 15:44:35');
INSERT INTO `ai_generation_task` VALUES (33, 103, 'superapi', 'Design a 4:5 sports art poster for \'ATHELETE_NAME\' using realistic, soft, thick painted motion fields, player’s leap translated into directional brush energy, a vertical ascension composition, and an emotional goal of disciplined transcendence and cold precision. \n\nCONCEPT: player is not just depicted—he is constructed out of force. His iconic jump is visualized as a surge of realistic paint strokes based on PLAYER’s team jersey colors, rising like a controlled explosion, turning athletic elevation into a visual language of upward pressure, discipline, and momentum. The poster captures the instant where physical power becomes abstract motion. \n\nSUBJECT: player rendered as a dominant semi-abstract figure emerging from layered, soft, freshly painted strokes rather than a fully literal photograph. His body is partially defined—recognizable facial structure and torso clarity—but limbs dissolve into sweeping, thick paint gestures, especially around the legs and arms, emphasizing lift and motion. The figure is angled upward, as if still climbing, occupying the central vertical axis but never fully contained. \n\nCOMPOSITION: A vertical ascension layout where the bottom third is dense with heavy, soft, realistic brush strokes, gradually opening into lighter, more fluid white space toward the top. The eye path starts at thick, grounded painted textures and travels upward through flowing lines and fragmented form into player’s mid-air presence. Negative space at the top acts as a zone of calm highlight contrast against the dense painted energy below. The background behaves like a freshly painted atmosphere, not a flat field, with directional strokes reinforcing upward motion.\n\nTYPOGRAPHY: Headline: \'RISE WITHOUT LIMIT\' set in a condensed athletic sans-serif brushed text, vertically stretched on the left side, and partially masked by soft paint strokes, as if emerging through layers. The baseline subtly curves upward, following the motion of the brushwork. \nSubhead: \'Discipline', 'gpt-image-2', 'medium', '1:1', '1024x1024', '1K', '', 1, 'failed', 100, NULL, NULL, '积分不足，请先充值', 5, NULL, NULL, 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-25 15:44:39', '', '2026-05-25 15:44:39');
INSERT INTO `ai_generation_task` VALUES (34, 103, 'superapi', 'Design a 4:5 sports art poster for \'ATHELETE_NAME\' using realistic, soft, thick painted motion fields, player’s leap translated into directional brush energy, a vertical ascension composition, and an emotional goal of disciplined transcendence and cold precision. \n\nCONCEPT: player is not just depicted—he is constructed out of force. His iconic jump is visualized as a surge of realistic paint strokes based on PLAYER’s team jersey colors, rising like a controlled explosion, turning athletic elevation into a visual language of upward pressure, discipline, and momentum. The poster captures the instant where physical power becomes abstract motion. \n\nSUBJECT: player rendered as a dominant semi-abstract figure emerging from layered, soft, freshly painted strokes rather than a fully literal photograph. His body is partially defined—recognizable facial structure and torso clarity—but limbs dissolve into sweeping, thick paint gestures, especially around the legs and arms, emphasizing lift and motion. The figure is angled upward, as if still climbing, occupying the central vertical axis but never fully contained. \n\nCOMPOSITION: A vertical ascension layout where the bottom third is dense with heavy, soft, realistic brush strokes, gradually opening into lighter, more fluid white space toward the top. The eye path starts at thick, grounded painted textures and travels upward through flowing lines and fragmented form into player’s mid-air presence. Negative space at the top acts as a zone of calm highlight contrast against the dense painted energy below. The background behaves like a freshly painted atmosphere, not a flat field, with directional strokes reinforcing upward motion.\n\nTYPOGRAPHY: Headline: \'RISE WITHOUT LIMIT\' set in a condensed athletic sans-serif brushed text, vertically stretched on the left side, and partially masked by soft paint strokes, as if emerging through layers. The baseline subtly curves upward, following the motion of the brushwork. \nSubhead: \'Discipline', 'gpt-image-2', 'medium', '1:1', '1024x1024', '1K', '', 1, 'failed', 100, NULL, NULL, '积分不足，请先充值', 5, NULL, NULL, 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-25 15:44:44', '', '2026-05-25 15:44:44');
INSERT INTO `ai_generation_task` VALUES (35, 103, 'superapi', 'Design a 4:5 sports art poster for \'ATHELETE_NAME\' using realistic, soft, thick painted motion fields, player’s leap translated into directional brush energy, a vertical ascension composition, and an emotional goal of disciplined transcendence and cold precision. \n\nCONCEPT: player is not just depicted—he is constructed out of force. His iconic jump is visualized as a surge of realistic paint strokes based on PLAYER’s team jersey colors, rising like a controlled explosion, turning athletic elevation into a visual language of upward pressure, discipline, and momentum. The poster captures the instant where physical power becomes abstract motion. \n\nSUBJECT: player rendered as a dominant semi-abstract figure emerging from layered, soft, freshly painted strokes rather than a fully literal photograph. His body is partially defined—recognizable facial structure and torso clarity—but limbs dissolve into sweeping, thick paint gestures, especially around the legs and arms, emphasizing lift and motion. The figure is angled upward, as if still climbing, occupying the central vertical axis but never fully contained. \n\nCOMPOSITION: A vertical ascension layout where the bottom third is dense with heavy, soft, realistic brush strokes, gradually opening into lighter, more fluid white space toward the top. The eye path starts at thick, grounded painted textures and travels upward through flowing lines and fragmented form into player’s mid-air presence. Negative space at the top acts as a zone of calm highlight contrast against the dense painted energy below. The background behaves like a freshly painted atmosphere, not a flat field, with directional strokes reinforcing upward motion.\n\nTYPOGRAPHY: Headline: \'RISE WITHOUT LIMIT\' set in a condensed athletic sans-serif brushed text, vertically stretched on the left side, and partially masked by soft paint strokes, as if emerging through layers. The baseline subtly curves upward, following the motion of the brushwork. \nSubhead: \'Discipline', 'gpt-image-2', 'medium', '1:1', '1024x1024', '1K', '', 1, 'failed', 100, NULL, NULL, '积分不足，请先充值', 5, NULL, NULL, 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-25 15:45:54', '', '2026-05-25 15:45:54');
INSERT INTO `ai_generation_task` VALUES (36, 103, 'superapi', 'Design a 4:5 sports art poster for \'ATHELETE_NAME\' using realistic, soft, thick painted motion fields, player’s leap translated into directional brush energy, a vertical ascension composition, and an emotional goal of disciplined transcendence and cold precision. \n\nCONCEPT: player is not just depicted—he is constructed out of force. His iconic jump is visualized as a surge of realistic paint strokes based on PLAYER’s team jersey colors, rising like a controlled explosion, turning athletic elevation into a visual language of upward pressure, discipline, and momentum. The poster captures the instant where physical power becomes abstract motion. \n\nSUBJECT: player rendered as a dominant semi-abstract figure emerging from layered, soft, freshly painted strokes rather than a fully literal photograph. His body is partially defined—recognizable facial structure and torso clarity—but limbs dissolve into sweeping, thick paint gestures, especially around the legs and arms, emphasizing lift and motion. The figure is angled upward, as if still climbing, occupying the central vertical axis but never fully contained. \n\nCOMPOSITION: A vertical ascension layout where the bottom third is dense with heavy, soft, realistic brush strokes, gradually opening into lighter, more fluid white space toward the top. The eye path starts at thick, grounded painted textures and travels upward through flowing lines and fragmented form into player’s mid-air presence. Negative space at the top acts as a zone of calm highlight contrast against the dense painted energy below. The background behaves like a freshly painted atmosphere, not a flat field, with directional strokes reinforcing upward motion.\n\nTYPOGRAPHY: Headline: \'RISE WITHOUT LIMIT\' set in a condensed athletic sans-serif brushed text, vertically stretched on the left side, and partially masked by soft paint strokes, as if emerging through layers. The baseline subtly curves upward, following the motion of the brushwork. \nSubhead: \'Discipline', 'gpt-image-2', 'medium', '1:1', '1024x1024', '1K', '', 1, 'failed', 100, NULL, NULL, '积分不足，请先充值', 5, NULL, NULL, 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-25 15:48:49', '', '2026-05-25 15:48:49');
INSERT INTO `ai_generation_task` VALUES (37, 103, 'superapi', 'Design a 4:5 sports art poster for \'ATHELETE_NAME\' using realistic, soft, thick painted motion fields, player’s leap translated into directional brush energy, a vertical ascension composition, and an emotional goal of disciplined transcendence and cold precision. \n\nCONCEPT: player is not just depicted—he is constructed out of force. His iconic jump is visualized as a surge of realistic paint strokes based on PLAYER’s team jersey colors, rising like a controlled explosion, turning athletic elevation into a visual language of upward pressure, discipline, and momentum. The poster captures the instant where physical power becomes abstract motion. \n\nSUBJECT: player rendered as a dominant semi-abstract figure emerging from layered, soft, freshly painted strokes rather than a fully literal photograph. His body is partially defined—recognizable facial structure and torso clarity—but limbs dissolve into sweeping, thick paint gestures, especially around the legs and arms, emphasizing lift and motion. The figure is angled upward, as if still climbing, occupying the central vertical axis but never fully contained. \n\nCOMPOSITION: A vertical ascension layout where the bottom third is dense with heavy, soft, realistic brush strokes, gradually opening into lighter, more fluid white space toward the top. The eye path starts at thick, grounded painted textures and travels upward through flowing lines and fragmented form into player’s mid-air presence. Negative space at the top acts as a zone of calm highlight contrast against the dense painted energy below. The background behaves like a freshly painted atmosphere, not a flat field, with directional strokes reinforcing upward motion.\n\nTYPOGRAPHY: Headline: \'RISE WITHOUT LIMIT\' set in a condensed athletic sans-serif brushed text, vertically stretched on the left side, and partially masked by soft paint strokes, as if emerging through layers. The baseline subtly curves upward, following the motion of the brushwork. \nSubhead: \'Discipline', 'gpt-image-2', 'medium', '1:1', '1024x1024', '1K', '', 1, 'failed', 100, NULL, NULL, '积分不足，请先充值', 5, NULL, NULL, 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-25 15:49:32', '', '2026-05-25 15:49:32');
INSERT INTO `ai_generation_task` VALUES (38, 103, 'superapi', 'Design a 4:5 sports art poster for \'ATHELETE_NAME\' using realistic, soft, thick painted motion fields, player’s leap translated into directional brush energy, a vertical ascension composition, and an emotional goal of disciplined transcendence and cold precision. \n\nCONCEPT: player is not just depicted—he is constructed out of force. His iconic jump is visualized as a surge of realistic paint strokes based on PLAYER’s team jersey colors, rising like a controlled explosion, turning athletic elevation into a visual language of upward pressure, discipline, and momentum. The poster captures the instant where physical power becomes abstract motion. \n\nSUBJECT: player rendered as a dominant semi-abstract figure emerging from layered, soft, freshly painted strokes rather than a fully literal photograph. His body is partially defined—recognizable facial structure and torso clarity—but limbs dissolve into sweeping, thick paint gestures, especially around the legs and arms, emphasizing lift and motion. The figure is angled upward, as if still climbing, occupying the central vertical axis but never fully contained. \n\nCOMPOSITION: A vertical ascension layout where the bottom third is dense with heavy, soft, realistic brush strokes, gradually opening into lighter, more fluid white space toward the top. The eye path starts at thick, grounded painted textures and travels upward through flowing lines and fragmented form into player’s mid-air presence. Negative space at the top acts as a zone of calm highlight contrast against the dense painted energy below. The background behaves like a freshly painted atmosphere, not a flat field, with directional strokes reinforcing upward motion.\n\nTYPOGRAPHY: Headline: \'RISE WITHOUT LIMIT\' set in a condensed athletic sans-serif brushed text, vertically stretched on the left side, and partially masked by soft paint strokes, as if emerging through layers. The baseline subtly curves upward, following the motion of the brushwork. \nSubhead: \'Discipline', 'gpt-image-2', 'medium', '1:1', '1024x1024', '1K', '', 1, 'failed', 100, NULL, NULL, '图片生成失败：流式响应连接异常，请重试', 5, NULL, '2026-05-25 15:50:19', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-25 15:50:18', '', '2026-05-25 15:50:19');
INSERT INTO `ai_generation_task` VALUES (39, 103, 'superapi', 'Design a 4:5 sports art poster for \'ATHELETE_NAME\' using realistic, soft, thick painted motion fields, player’s leap translated into directional brush energy, a vertical ascension composition, and an emotional goal of disciplined transcendence and cold precision. \n\nCONCEPT: player is not just depicted—he is constructed out of force. His iconic jump is visualized as a surge of realistic paint strokes based on PLAYER’s team jersey colors, rising like a controlled explosion, turning athletic elevation into a visual language of upward pressure, discipline, and momentum. The poster captures the instant where physical power becomes abstract motion. \n\nSUBJECT: player rendered as a dominant semi-abstract figure emerging from layered, soft, freshly painted strokes rather than a fully literal photograph. His body is partially defined—recognizable facial structure and torso clarity—but limbs dissolve into sweeping, thick paint gestures, especially around the legs and arms, emphasizing lift and motion. The figure is angled upward, as if still climbing, occupying the central vertical axis but never fully contained. \n\nCOMPOSITION: A vertical ascension layout where the bottom third is dense with heavy, soft, realistic brush strokes, gradually opening into lighter, more fluid white space toward the top. The eye path starts at thick, grounded painted textures and travels upward through flowing lines and fragmented form into player’s mid-air presence. Negative space at the top acts as a zone of calm highlight contrast against the dense painted energy below. The background behaves like a freshly painted atmosphere, not a flat field, with directional strokes reinforcing upward motion.\n\nTYPOGRAPHY: Headline: \'RISE WITHOUT LIMIT\' set in a condensed athletic sans-serif brushed text, vertically stretched on the left side, and partially masked by soft paint strokes, as if emerging through layers. The baseline subtly curves upward, following the motion of the brushwork. \nSubhead: \'Discipline', 'gpt-image-2', 'medium', '1:1', '1024x1024', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/25/a8363ecb-4009-4d10-bce1-a2624ed7afe8.jpg', '/profile/upload/2026/05/25/a8363ecb-4009-4d10-bce1-a2624ed7afe8.jpg', NULL, 5, NULL, '2026-05-25 16:02:33', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-25 16:01:11', '', '2026-05-25 16:02:33');
INSERT INTO `ai_generation_task` VALUES (40, 103, 'superapi', 'Design a 4:5 sports art poster for \'ATHELETE_NAME\' using realistic, soft, thick painted motion fields, player’s leap translated into directional brush energy, a vertical ascension composition, and an emotional goal of disciplined transcendence and cold precision. \n\nCONCEPT: player is not just depicted—he is constructed out of force. His iconic jump is visualized as a surge of realistic paint strokes based on PLAYER’s team jersey colors, rising like a controlled explosion, turning athletic elevation into a visual language of upward pressure, discipline, and momentum. The poster captures the instant where physical power becomes abstract motion. \n\nSUBJECT: player rendered as a dominant semi-abstract figure emerging from layered, soft, freshly painted strokes rather than a fully literal photograph. His body is partially defined—recognizable facial structure and torso clarity—but limbs dissolve into sweeping, thick paint gestures, especially around the legs and arms, emphasizing lift and motion. The figure is angled upward, as if still climbing, occupying the central vertical axis but never fully contained. \n\nCOMPOSITION: A vertical ascension layout where the bottom third is dense with heavy, soft, realistic brush strokes, gradually opening into lighter, more fluid white space toward the top. The eye path starts at thick, grounded painted textures and travels upward through flowing lines and fragmented form into player’s mid-air presence. Negative space at the top acts as a zone of calm highlight contrast against the dense painted energy below. The background behaves like a freshly painted atmosphere, not a flat field, with directional strokes reinforcing upward motion.\n\nTYPOGRAPHY: Headline: \'RISE WITHOUT LIMIT\' set in a condensed athletic sans-serif brushed text, vertically stretched on the left side, and partially masked by soft paint strokes, as if emerging through layers. The baseline subtly curves upward, following the motion of the brushwork. \nSubhead: \'Discipline', 'gpt-image-2', 'medium', '1:1', '1024x1024', '1K', '', 1, 'failed', 100, NULL, NULL, '图片生成响应异常，本地未收到生成结果，请重试', 5, NULL, '2026-05-25 16:09:24', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-25 16:08:23', '', '2026-05-25 16:09:24');
INSERT INTO `ai_generation_task` VALUES (41, 103, 'superapi', 'Design a 4:5 sports art poster for \'ATHELETE_NAME\' using realistic, soft, thick painted motion fields, player’s leap translated into directional brush energy, a vertical ascension composition, and an emotional goal of disciplined transcendence and cold precision. \n\nCONCEPT: player is not just depicted—he is constructed out of force. His iconic jump is visualized as a surge of realistic paint strokes based on PLAYER’s team jersey colors, rising like a controlled explosion, turning athletic elevation into a visual language of upward pressure, discipline, and momentum. The poster captures the instant where physical power becomes abstract motion. \n\nSUBJECT: player rendered as a dominant semi-abstract figure emerging from layered, soft, freshly painted strokes rather than a fully literal photograph. His body is partially defined—recognizable facial structure and torso clarity—but limbs dissolve into sweeping, thick paint gestures, especially around the legs and arms, emphasizing lift and motion. The figure is angled upward, as if still climbing, occupying the central vertical axis but never fully contained. \n\nCOMPOSITION: A vertical ascension layout where the bottom third is dense with heavy, soft, realistic brush strokes, gradually opening into lighter, more fluid white space toward the top. The eye path starts at thick, grounded painted textures and travels upward through flowing lines and fragmented form into player’s mid-air presence. Negative space at the top acts as a zone of calm highlight contrast against the dense painted energy below. The background behaves like a freshly painted atmosphere, not a flat field, with directional strokes reinforcing upward motion.\n\nTYPOGRAPHY: Headline: \'RISE WITHOUT LIMIT\' set in a condensed athletic sans-serif brushed text, vertically stretched on the left side, and partially masked by soft paint strokes, as if emerging through layers. The baseline subtly curves upward, following the motion of the brushwork. \nSubhead: \'Discipline', 'gpt-image-2', 'medium', '1:1', '1024x1024', '1K', '', 1, 'processing', 95, NULL, NULL, '图片生成已提交，上游仍可能继续处理，请稍后到作品中查看', 5, NULL, NULL, 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-25 16:15:30', '', '2026-05-25 16:16:31');
INSERT INTO `ai_generation_task` VALUES (42, 103, 'superapi', '6', 'gpt-image-2', 'medium', '1:1', '1024x1024', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/25/74bd0830-86b0-498f-977b-1d0217205c46.jpg', '/profile/upload/2026/05/25/74bd0830-86b0-498f-977b-1d0217205c46.jpg', NULL, 5, NULL, '2026-05-25 16:28:54', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-25 16:28:36', '', '2026-05-25 16:28:54');
INSERT INTO `ai_generation_task` VALUES (43, 103, 'grsai', '7', 'gpt-image-2', 'medium', '1:1', '1024x1024', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/25/bd23bda0-0807-445a-8d56-4276b55259b5.png', '/profile/upload/2026/05/25/bd23bda0-0807-445a-8d56-4276b55259b5.png', NULL, 5, NULL, '2026-05-25 16:40:46', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-25 16:39:19', '', '2026-05-25 16:40:46');
INSERT INTO `ai_generation_task` VALUES (44, 103, 'grsai', '8', 'nano-banana-2', 'medium', '1:1', '1024x1024', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/25/6443696c-d1b6-44ae-82be-a4a2898b605c.png', '/profile/upload/2026/05/25/6443696c-d1b6-44ae-82be-a4a2898b605c.png', NULL, 5, NULL, '2026-05-25 17:11:33', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-25 17:10:51', '', '2026-05-25 17:11:33');
INSERT INTO `ai_generation_task` VALUES (45, 103, 'grsai', '生成一只小兔子', 'nano-banana-2', 'medium', '1:1', '1024x1024', '1K', '', 1, 'deleted', 100, '/profile/upload/2026/05/25/b622207d-fef3-43c8-a7b8-289af5a99cf5.png', '/profile/upload/2026/05/25/b622207d-fef3-43c8-a7b8-289af5a99cf5.png', '用户删除', 5, NULL, '2026-05-25 17:17:46', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-25 17:17:06', '', '2026-05-26 21:40:01');
INSERT INTO `ai_generation_task` VALUES (46, 103, 'grsai', '2', 'gpt-image-2', 'low', '1:1', '1024x1024', '1K', '', 1, 'deleted', 100, '/profile/upload/2026/05/26/8ce5d7ec-ed29-4b36-9414-25df75720bd7.png', '/profile/upload/2026/05/26/8ce5d7ec-ed29-4b36-9414-25df75720bd7.png', '用户删除', 6, NULL, '2026-05-26 01:38:49', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 01:37:54', '', '2026-05-26 21:39:58');
INSERT INTO `ai_generation_task` VALUES (47, 103, 'grsai', '3', 'gpt-image-2-vip', 'medium', '1:1', '2048x2048', '2K', '', 1, 'failed', 100, NULL, NULL, '图片生成失败：gpt-image-2-vip model does not support 1:1 parameter, please use pixel value input, for example: 1024x1024', 18, NULL, '2026-05-26 01:41:03', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 01:40:59', '', '2026-05-26 01:41:02');
INSERT INTO `ai_generation_task` VALUES (48, 103, 'grsai', '3', 'gpt-image-2-vip', 'auto', '1:1', '2048x2048', '2K', '', 1, 'failed', 100, NULL, NULL, '图片生成失败：gpt-image-2-vip model does not support 1:1 parameter, please use pixel value input, for example: 1024x1024', 18, NULL, '2026-05-26 01:47:57', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 01:47:42', '', '2026-05-26 01:47:57');
INSERT INTO `ai_generation_task` VALUES (49, 103, 'grsai', '3', 'gpt-image-2-vip', 'auto', '1:1', '1024x1024', '1K', '', 1, 'failed', 100, NULL, NULL, '图片生成失败：gpt-image-2-vip model does not support 1:1 parameter, please use pixel value input, for example: 1024x1024', 15, NULL, '2026-05-26 01:49:11', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 01:49:07', '', '2026-05-26 01:49:10');
INSERT INTO `ai_generation_task` VALUES (50, 103, 'grsai', '3', 'gpt-image-2-vip', 'auto', '1:1', '2048x2048', '2K', '', 1, 'deleted', 100, '/profile/upload/2026/05/26/affb22f0-f022-42ca-bb76-711f8b11beb4.png', '/profile/upload/2026/05/26/affb22f0-f022-42ca-bb76-711f8b11beb4.png', '用户删除', 18, NULL, '2026-05-26 01:51:05', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 01:50:24', '', '2026-05-28 08:06:01');
INSERT INTO `ai_generation_task` VALUES (51, 103, 'grsai', 'Limited edition sneaker release poster, sneakers levitating in mid-air, flame special effects background', 'gpt-image-2-vip', 'auto', '5:4', '2240x1792', '2K', '', 1, 'deleted', 100, '/profile/upload/2026/05/26/59951c99-75a1-4752-bff6-b5ae8045fa9b.png', '/profile/upload/2026/05/26/59951c99-75a1-4752-bff6-b5ae8045fa9b.png', '用户删除', 18, NULL, '2026-05-26 01:54:14', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 01:53:06', '', '2026-05-28 08:05:57');
INSERT INTO `ai_generation_task` VALUES (52, 103, 'grsai', '5', 'gpt-image-2-vip', 'auto', '1:1', '1024x1024', '1K', '', 1, 'deleted', 100, '/profile/upload/2026/05/26/c818fa23-27fa-4c20-a09d-8d6d367caa3f.png', '/profile/upload/2026/05/26/c818fa23-27fa-4c20-a09d-8d6d367caa3f.png', '用户删除', 15, NULL, '2026-05-26 02:05:22', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 02:04:39', '', '2026-05-28 08:05:57');
INSERT INTO `ai_generation_task` VALUES (53, 103, 'superapi', 'A Cat with Navy Seal military outfit, sun-glasses, heavy armor, tactical, weapon is MK18 with full tactical accessory. unreal engine 5, video game concept', 'gpt-image-2-vip', 'auto', '1:1', '1024x1024', '1K', '', 2, 'failed', 100, NULL, NULL, '图片生成失败：流式响应连接异常（ConnectException：无详细信息），请重试', 30, NULL, '2026-05-26 19:20:46', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 19:20:46', '', '2026-05-26 19:20:46');
INSERT INTO `ai_generation_task` VALUES (54, 103, 'grsai', 'A Cat with Navy Seal military outfit, sun-glasses, heavy armor, tactical, weapon is MK18 with full tactical accessory. unreal engine 5, video game concept', 'gpt-image-2-vip', 'auto', '1:1', '1024x1024', '1K', '', 2, 'failed', 100, NULL, NULL, '生成超时，请稍后重试', 30, NULL, '2026-05-26 19:24:06', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 19:21:44', '', '2026-05-26 19:24:05');
INSERT INTO `ai_generation_task` VALUES (55, 103, 'grsai', 'Ultra-detailed anime brand mascot poster, full-body character redesign inspired by iconic fast-food branding, cyber streetwear fashion, oversized techwear jacket, layered straps, utility belts, cargo pants, branded sneakers, chains, patches, mascot-themed accessories, dynamic confident pose, clean white poster background with bold red/yellow/orange graphic accents, manga-style linework, cel-shaded anime rendering, high-fashion hypebeast aesthetic, Japanese typography, infographic-style layout, promotional side panels, fictional stats and profile sections, logos, slogans, barcode elements, paint splashes, distressed print texture, collectible character card design, commercial advertising meets anime editorial, vibrant color blocking, cinematic lighting, ultra sharp details, energetic composition, luxury streetwear branding, modern poster design, vertical format, premium anime key visual, highly stylized, artstation quality.', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 2, 'deleted', 100, '/profile/upload/2026/05/26/472c62ef-3bd9-40c9-a150-4e5f291cc886.png', '/profile/upload/2026/05/26/472c62ef-3bd9-40c9-a150-4e5f291cc886.png', '用户删除', 12, NULL, '2026-05-26 22:11:27', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 22:10:03', '', '2026-05-28 08:05:56');
INSERT INTO `ai_generation_task` VALUES (56, 103, 'superapi', 'Ultra-detailed anime brand mascot poster, full-body character redesign inspired by iconic fast-food branding, cyber streetwear fashion, oversized techwear jacket, layered straps, utility belts, cargo pants, branded sneakers, chains, patches, mascot-themed accessories, dynamic confident pose, clean white poster background with bold red/yellow/orange graphic accents, manga-style linework, cel-shaded anime rendering, high-fashion hypebeast aesthetic, Japanese typography, infographic-style layout, promotional side panels, fictional stats and profile sections, logos, slogans, barcode elements, paint splashes, distressed print texture, collectible character card design, commercial advertising meets anime editorial, vibrant color blocking, cinematic lighting, ultra sharp details, energetic composition, luxury streetwear branding, modern poster design, vertical format, premium anime key visual, highly stylized, artstation quality.', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 2, 'failed', 100, NULL, NULL, '图片生成失败：图片生成失败：流式响应连接异常（ConnectException：无详细信息），请重试；图片生成失败：流式响应连接异常（ConnectException：无详细信息），请重试', 12, NULL, '2026-05-26 22:13:38', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 22:13:36', '', '2026-05-26 22:13:37');
INSERT INTO `ai_generation_task` VALUES (57, 103, 'superapi', 'Ultra-detailed anime brand mascot poster, full-body character redesign inspired by iconic fast-food branding, cyber streetwear fashion, oversized techwear jacket, layered straps, utility belts, cargo pants, branded sneakers, chains, patches, mascot-themed accessories, dynamic confident pose, clean white poster background with bold red/yellow/orange graphic accents, manga-style linework, cel-shaded anime rendering, high-fashion hypebeast aesthetic, Japanese typography, infographic-style layout, promotional side panels, fictional stats and profile sections, logos, slogans, barcode elements, paint splashes, distressed print texture, collectible character card design, commercial advertising meets anime editorial, vibrant color blocking, cinematic lighting, ultra sharp details, energetic composition, luxury streetwear branding, modern poster design, vertical format, premium anime key visual, highly stylized, artstation quality.', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 2, 'failed', 100, NULL, NULL, '图片生成失败：流式响应连接异常（ConnectException：无详细信息），请重试', 12, NULL, '2026-05-26 22:17:30', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 22:17:29', '', '2026-05-26 22:17:30');
INSERT INTO `ai_generation_task` VALUES (58, 103, 'superapi', 'Ultra-detailed anime brand mascot poster, full-body character redesign inspired by iconic fast-food branding, cyber streetwear fashion, oversized techwear jacket, layered straps, utility belts, cargo pants, branded sneakers, chains, patches, mascot-themed accessories, dynamic confident pose, clean white poster background with bold red/yellow/orange graphic accents, manga-style linework, cel-shaded anime rendering, high-fashion hypebeast aesthetic, Japanese typography, infographic-style layout, promotional side panels, fictional stats and profile sections, logos, slogans, barcode elements, paint splashes, distressed print texture, collectible character card design, commercial advertising meets anime editorial, vibrant color blocking, cinematic lighting, ultra sharp details, energetic composition, luxury streetwear branding, modern poster design, vertical format, premium anime key visual, highly stylized, artstation quality.', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 2, 'failed', 100, NULL, NULL, '图片生成失败：流式响应连接异常（ConnectException：无详细信息），请重试', 12, NULL, '2026-05-26 22:17:39', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 22:17:39', '', '2026-05-26 22:17:39');
INSERT INTO `ai_generation_task` VALUES (59, 103, 'superapi', 'Ultra-detailed anime brand mascot poster, full-body character redesign inspired by iconic fast-food branding, cyber streetwear fashion, oversized techwear jacket, layered straps, utility belts, cargo pants, branded sneakers, chains, patches, mascot-themed accessories, dynamic confident pose, clean white poster background with bold red/yellow/orange graphic accents, manga-style linework, cel-shaded anime rendering, high-fashion hypebeast aesthetic, Japanese typography, infographic-style layout, promotional side panels, fictional stats and profile sections, logos, slogans, barcode elements, paint splashes, distressed print texture, collectible character card design, commercial advertising meets anime editorial, vibrant color blocking, cinematic lighting, ultra sharp details, energetic composition, luxury streetwear branding, modern poster design, vertical format, premium anime key visual, highly stylized, artstation quality.', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 2, 'failed', 100, NULL, NULL, '图片生成失败：流式响应连接异常（ConnectException：无详细信息），请重试', 12, NULL, '2026-05-26 22:18:05', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 22:18:05', '', '2026-05-26 22:18:05');
INSERT INTO `ai_generation_task` VALUES (60, 103, 'superapi', 'Ultra-detailed anime brand mascot poster, full-body character redesign inspired by iconic fast-food branding, cyber streetwear fashion, oversized techwear jacket, layered straps, utility belts, cargo pants, branded sneakers, chains, patches, mascot-themed accessories, dynamic confident pose, clean white poster background with bold red/yellow/orange graphic accents, manga-style linework, cel-shaded anime rendering, high-fashion hypebeast aesthetic, Japanese typography, infographic-style layout, promotional side panels, fictional stats and profile sections, logos, slogans, barcode elements, paint splashes, distressed print texture, collectible character card design, commercial advertising meets anime editorial, vibrant color blocking, cinematic lighting, ultra sharp details, energetic composition, luxury streetwear branding, modern poster design, vertical format, premium anime key visual, highly stylized, artstation quality.', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 2, 'failed', 100, NULL, NULL, '图片生成失败：流式响应连接异常（ConnectException：无详细信息），请重试', 12, NULL, '2026-05-26 22:20:32', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 22:20:31', '', '2026-05-26 22:20:31');
INSERT INTO `ai_generation_task` VALUES (61, 103, 'superapi', 'Ultra-detailed anime brand mascot poster, full-body character redesign inspired by iconic fast-food branding, cyber streetwear fashion, oversized techwear jacket, layered straps, utility belts, cargo pants, branded sneakers, chains, patches, mascot-themed accessories, dynamic confident pose, clean white poster background with bold red/yellow/orange graphic accents, manga-style linework, cel-shaded anime rendering, high-fashion hypebeast aesthetic, Japanese typography, infographic-style layout, promotional side panels, fictional stats and profile sections, logos, slogans, barcode elements, paint splashes, distressed print texture, collectible character card design, commercial advertising meets anime editorial, vibrant color blocking, cinematic lighting, ultra sharp details, energetic composition, luxury streetwear branding, modern poster design, vertical format, premium anime key visual, highly stylized, artstation quality.', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 2, 'failed', 100, NULL, NULL, '图片生成失败：null', 12, NULL, '2026-05-26 22:21:03', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 22:21:02', '', '2026-05-26 22:21:02');
INSERT INTO `ai_generation_task` VALUES (62, 103, 'superapi', 'Ultra-detailed anime brand mascot poster, full-body character redesign inspired by iconic fast-food branding, cyber streetwear fashion, oversized techwear jacket, layered straps, utility belts, cargo pants, branded sneakers, chains, patches, mascot-themed accessories, dynamic confident pose, clean white poster background with bold red/yellow/orange graphic accents, manga-style linework, cel-shaded anime rendering, high-fashion hypebeast aesthetic, Japanese typography, infographic-style layout, promotional side panels, fictional stats and profile sections, logos, slogans, barcode elements, paint splashes, distressed print texture, collectible character card design, commercial advertising meets anime editorial, vibrant color blocking, cinematic lighting, ultra sharp details, energetic composition, luxury streetwear branding, modern poster design, vertical format, premium anime key visual, highly stylized, artstation quality.', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 2, 'failed', 100, NULL, NULL, '图片生成失败：null', 12, NULL, '2026-05-26 22:21:08', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 22:21:08', '', '2026-05-26 22:21:08');
INSERT INTO `ai_generation_task` VALUES (63, 103, 'superapi', 'Ultra-detailed anime brand mascot poster, full-body character redesign inspired by iconic fast-food branding, cyber streetwear fashion, oversized techwear jacket, layered straps, utility belts, cargo pants, branded sneakers, chains, patches, mascot-themed accessories, dynamic confident pose, clean white poster background with bold red/yellow/orange graphic accents, manga-style linework, cel-shaded anime rendering, high-fashion hypebeast aesthetic, Japanese typography, infographic-style layout, promotional side panels, fictional stats and profile sections, logos, slogans, barcode elements, paint splashes, distressed print texture, collectible character card design, commercial advertising meets anime editorial, vibrant color blocking, cinematic lighting, ultra sharp details, energetic composition, luxury streetwear branding, modern poster design, vertical format, premium anime key visual, highly stylized, artstation quality.', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 2, 'failed', 100, NULL, NULL, '图片生成失败：null', 12, NULL, '2026-05-26 22:21:14', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 22:21:13', '', '2026-05-26 22:21:14');
INSERT INTO `ai_generation_task` VALUES (64, 103, 'superapi', 'Ultra-detailed anime brand mascot poster, full-body character redesign inspired by iconic fast-food branding, cyber streetwear fashion, oversized techwear jacket, layered straps, utility belts, cargo pants, branded sneakers, chains, patches, mascot-themed accessories, dynamic confident pose, clean white poster background with bold red/yellow/orange graphic accents, manga-style linework, cel-shaded anime rendering, high-fashion hypebeast aesthetic, Japanese typography, infographic-style layout, promotional side panels, fictional stats and profile sections, logos, slogans, barcode elements, paint splashes, distressed print texture, collectible character card design, commercial advertising meets anime editorial, vibrant color blocking, cinematic lighting, ultra sharp details, energetic composition, luxury streetwear branding, modern poster design, vertical format, premium anime key visual, highly stylized, artstation quality.', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 2, 'failed', 100, NULL, NULL, '图片生成失败：null', 12, NULL, '2026-05-26 22:21:18', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 22:21:17', '', '2026-05-26 22:21:17');
INSERT INTO `ai_generation_task` VALUES (65, 103, 'superapi', 'Ultra-detailed anime brand mascot poster, full-body character redesign inspired by iconic fast-food branding, cyber streetwear fashion, oversized techwear jacket, layered straps, utility belts, cargo pants, branded sneakers, chains, patches, mascot-themed accessories, dynamic confident pose, clean white poster background with bold red/yellow/orange graphic accents, manga-style linework, cel-shaded anime rendering, high-fashion hypebeast aesthetic, Japanese typography, infographic-style layout, promotional side panels, fictional stats and profile sections, logos, slogans, barcode elements, paint splashes, distressed print texture, collectible character card design, commercial advertising meets anime editorial, vibrant color blocking, cinematic lighting, ultra sharp details, energetic composition, luxury streetwear branding, modern poster design, vertical format, premium anime key visual, highly stylized, artstation quality.', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 2, 'failed', 100, NULL, NULL, '生成结果数量不足：期望 2 张，实际 1 张', 12, NULL, '2026-05-26 22:23:01', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 22:21:41', '', '2026-05-26 22:23:01');
INSERT INTO `ai_generation_task` VALUES (66, 103, 'superapi', 'Limited edition sneaker release poster, sneakers levitating in mid-air, flame special effects background', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 2, 'failed', 100, NULL, NULL, '图片生成失败：null', 12, NULL, '2026-05-26 22:36:08', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 22:36:07', '', '2026-05-26 22:36:07');
INSERT INTO `ai_generation_task` VALUES (67, 103, 'superapi', 'Limited edition sneaker release poster, sneakers levitating in mid-air, flame special effects background', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 2, 'failed', 100, NULL, NULL, '图片生成失败：流式响应连接异常（ConnectException：无详细信息），请重试', 12, NULL, '2026-05-26 22:36:23', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 22:36:22', '', '2026-05-26 22:36:22');
INSERT INTO `ai_generation_task` VALUES (68, 103, 'superapi', 'Limited edition sneaker release poster, sneakers levitating in mid-air, flame special effects background', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 2, 'failed', 100, NULL, NULL, '图片生成失败：流式响应连接异常（ConnectException：无详细信息），请重试', 12, NULL, '2026-05-26 22:45:06', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 22:45:05', '', '2026-05-26 22:45:06');
INSERT INTO `ai_generation_task` VALUES (69, 103, 'superapi', 'Limited edition sneaker release poster, sneakers levitating in mid-air, flame special effects background', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 2, 'failed', 100, NULL, NULL, '图片生成失败：流式响应连接异常（ConnectException：无详细信息），请重试', 12, NULL, '2026-05-26 22:47:55', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 22:47:54', '', '2026-05-26 22:47:55');
INSERT INTO `ai_generation_task` VALUES (70, 103, 'superapi', 'Limited edition sneaker release poster, sneakers levitating in mid-air, flame special effects background', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 2, 'failed', 100, NULL, NULL, '图片生成失败：流式响应连接异常（SSLHandshakeException：Remote host terminated the handshake），请重试', 12, NULL, '2026-05-26 22:55:54', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 22:55:51', '', '2026-05-26 22:55:54');
INSERT INTO `ai_generation_task` VALUES (71, 103, 'superapi', 'Limited edition sneaker release poster, sneakers levitating in mid-air, flame special effects background', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 2, 'deleted', 100, 'https://gpt2image.superapi.buzz/api/storage/generations/lpCySTtezG9YHYM9NDyx3iK3IGlIE7Oz/-_YaRgxHOLExBCtIjTqx6ynV3SvTBJMa.jpg,/profile/upload/2026/05/26/69f95edc-1971-4671-b446-84b4a114d1b0.jpg', 'https://gpt2image.superapi.buzz/api/storage/generations/lpCySTtezG9YHYM9NDyx3iK3IGlIE7Oz/-_YaRgxHOLExBCtIjTqx6ynV3SvTBJMa.jpg,/profile/upload/2026/05/26/69f95edc-1971-4671-b446-84b4a114d1b0.jpg', '用户删除', 12, NULL, '2026-05-26 23:01:13', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 22:59:30', '', '2026-05-28 08:05:55');
INSERT INTO `ai_generation_task` VALUES (72, 103, 'grsai', '9', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 2, 'deleted', 100, '/profile/upload/2026/05/26/9c4f74cc-e293-4d8a-b700-bb5341343718.png,/profile/upload/2026/05/26/6b3a9b1c-e4de-4662-b8bd-7bbea98aeefb.png', '/profile/upload/2026/05/26/9c4f74cc-e293-4d8a-b700-bb5341343718.png', '用户删除', 12, NULL, '2026-05-26 23:46:58', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 23:45:18', '', '2026-05-28 08:05:53');
INSERT INTO `ai_generation_task` VALUES (73, 103, 'grsai', '10', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 2, 'deleted', 100, '/profile/upload/2026/05/26/e686a642-90ee-440b-af63-5c10eb1d631a.png,/profile/upload/2026/05/26/33ebf5cf-fd2b-4658-bdf3-929585d2d3ac.png', '/profile/upload/2026/05/26/e686a642-90ee-440b-af63-5c10eb1d631a.png', '用户删除', 12, NULL, '2026-05-26 23:55:17', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-26 23:54:04', '', '2026-05-28 08:05:52');
INSERT INTO `ai_generation_task` VALUES (74, 103, 'grsai', '11', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 1, 'pending', 0, NULL, NULL, NULL, 6, NULL, NULL, 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-27 00:12:32', '', NULL);
INSERT INTO `ai_generation_task` VALUES (75, 103, 'grsai', '11', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 1, 'failed', 100, NULL, NULL, '图片生成失败：We are sorry, but the images we created may have violated our relevant policies. If you think we made a mistake, please try again or edit your prompt.', 6, '2026-05-27 00:13:25', '2026-05-27 00:13:46', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-27 00:13:25', '', '2026-05-27 00:13:45');
INSERT INTO `ai_generation_task` VALUES (76, 103, 'grsai', '1', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 1, 'failed', 100, NULL, NULL, '图片生成失败：We are sorry, but the images we created may have violated our relevant policies. If you think we made a mistake, please try again or edit your prompt.', 6, '2026-05-27 00:14:14', '2026-05-27 00:14:31', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-27 00:14:13', '', '2026-05-27 00:14:30');
INSERT INTO `ai_generation_task` VALUES (77, 103, 'grsai', '小猫', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 1, 'deleted', 100, '/profile/upload/2026/05/27/0e0fa7b9-70af-4272-8c4d-41439424ae00.png', '/profile/upload/2026/05/27/0e0fa7b9-70af-4272-8c4d-41439424ae00.png', '用户删除', 6, '2026-05-27 00:14:55', '2026-05-27 00:16:01', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-27 00:14:54', '', '2026-05-28 08:05:59');
INSERT INTO `ai_generation_task` VALUES (78, 103, 'grsai', '小狗', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 1, 'deleted', 100, '/profile/upload/2026/05/27/5365c61a-cae7-4336-a017-936d257643ba.png', '/profile/upload/2026/05/27/5365c61a-cae7-4336-a017-936d257643ba.png', '用户删除', 6, '2026-05-27 00:32:15', '2026-05-27 00:33:45', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-27 00:32:15', '', '2026-05-28 08:05:50');
INSERT INTO `ai_generation_task` VALUES (79, 103, 'grsai', '小乌龟', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 1, 'deleted', 100, '/profile/upload/2026/05/27/1b9f677d-3b3c-425b-8edb-1d47477a0171.png', '/profile/upload/2026/05/27/1b9f677d-3b3c-425b-8edb-1d47477a0171.png', '用户删除', 6, '2026-05-27 00:34:21', '2026-05-27 00:35:24', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-27 00:34:21', '', '2026-05-28 08:05:51');
INSERT INTO `ai_generation_task` VALUES (80, 103, 'grsai', '# Role:\nYou are an expert Visual Anthropologist and Knolling Photographer. Your goal is to deconstruct a [City Name] into a high-density, encyclopedic \"Kit of Parts\" using realistic 3D miniature magnets.\n\n# Critical Constraints (The \"Anti-Duplication\" Rule):\n**STRICT NO REPETITION:** Every single item in the collection must be a completely distinct object category. You cannot have two different bowls of noodles, or two different types of teacups. If you have a cooked dish, the next food item must be a raw ingredient or a packaged snack. **Diversity is key.**\n\n# Design Guidelines:\n\n1.  **Layout & Density:**\n    * **Strict Knolling Grid:** All items arranged in perfect parallel lines and 90-degree angles.\n    * **High Count:** Aim for 15-20 distinct items filling the frame evenly.\n    * **Centerpiece:** The main landmark sits in the middle, surrounded by the smaller cultural artifacts.\n\n2.  **Content Categories (Must define specific, non-repeating items across these tiers):**\n\n    * **Tier 1: Architecture & Space**\n        * 1x Main Landmark Model (Centerpiece).\n        * 1x Secondary Urban Element (e.g., A specific street sign, an ancient gate, a unique lamppost).\n\n    * **Tier 2: Gastronomy (The full spectrum)**\n        * 1x Signature Finished Dish (Cooked).\n        * 1x Iconic Street Snack (Ready-to-eat).\n        * **1x Raw Biodiversity/Ingredient Source** (Crucial: e.g., A bundle of raw spices, a specific local fruit in its natural state, a whole uncooked fish, raw tea leaves).\n\n    * **Tier 3: People & Culture (Deep Dive)**\n        * 1x Typical Character Figurine (e.g., A local profession).\n        * **1x Ethnic/Historical Costume Figurine** (Specific to the region\'s minority groups or deep history, distinct from the typical character).\n        * 1x Cultural Artifact/Tool (e.g., Musical instrument, game piece, traditional craft tool).\n\n    * **Tier 4: Life & Nature**\n        * 1x Distinctive Local Transport vehicle.\n        * 1x Representative Flora or Fauna (Pla', 'nano-banana-pro', 'auto', '1:1', '1024x1024', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/27/0c8191ab-e23e-4b02-8eaa-9c13f2c3c1da.png', '/profile/upload/2026/05/27/0c8191ab-e23e-4b02-8eaa-9c13f2c3c1da.png', NULL, 20, '2026-05-27 11:56:33', '2026-05-27 11:57:31', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-27 11:56:32', '', '2026-05-27 11:57:34');
INSERT INTO `ai_generation_task` VALUES (81, 103, 'grsai', '# Role:\nYou are an expert Visual Anthropologist and Knolling Photographer. Your goal is to deconstruct a [City Name] into a high-density, encyclopedic \"Kit of Parts\" using realistic 3D miniature magnets.\n\n# Critical Constraints (The \"Anti-Duplication\" Rule):\n**STRICT NO REPETITION:** Every single item in the collection must be a completely distinct object category. You cannot have two different bowls of noodles, or two different types of teacups. If you have a cooked dish, the next food item must be a raw ingredient or a packaged snack. **Diversity is key.**\n\n# Design Guidelines:\n\n1.  **Layout & Density:**\n    * **Strict Knolling Grid:** All items arranged in perfect parallel lines and 90-degree angles.\n    * **High Count:** Aim for 15-20 distinct items filling the frame evenly.\n    * **Centerpiece:** The main landmark sits in the middle, surrounded by the smaller cultural artifacts.\n\n2.  **Content Categories (Must define specific, non-repeating items across these tiers):**\n\n    * **Tier 1: Architecture & Space**\n        * 1x Main Landmark Model (Centerpiece).\n        * 1x Secondary Urban Element (e.g., A specific street sign, an ancient gate, a unique lamppost).\n\n    * **Tier 2: Gastronomy (The full spectrum)**\n        * 1x Signature Finished Dish (Cooked).\n        * 1x Iconic Street Snack (Ready-to-eat).\n        * **1x Raw Biodiversity/Ingredient Source** (Crucial: e.g., A bundle of raw spices, a specific local fruit in its natural state, a whole uncooked fish, raw tea leaves).\n\n    * **Tier 3: People & Culture (Deep Dive)**\n        * 1x Typical Character Figurine (e.g., A local profession).\n        * **1x Ethnic/Historical Costume Figurine** (Specific to the region\'s minority groups or deep history, distinct from the typical character).\n        * 1x Cultural Artifact/Tool (e.g., Musical instrument, game piece, traditional craft tool).\n\n    * **Tier 4: Life & Nature**\n        * 1x Distinctive Local Transport vehicle.\n        * 1x Representative Flora or Fauna (Pla', 'nano-banana-2', 'auto', '1:1', '1024x1024', '1K', '', 2, 'success', 100, '/profile/upload/2026/05/27/52deb7f2-823f-4dc8-94a9-4f3ad2cb5d0d.png,/profile/upload/2026/05/27/19029e1b-c982-4545-b3b0-5885fa885f7b.png', '/profile/upload/2026/05/27/52deb7f2-823f-4dc8-94a9-4f3ad2cb5d0d.png', NULL, 24, '2026-05-27 11:59:07', '2026-05-27 11:59:35', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-27 11:59:07', '', '2026-05-27 11:59:52');
INSERT INTO `ai_generation_task` VALUES (82, 103, 'grsai', 'A stunning hyper-realistic arrangement of fresh fruits, including red and green apples, strawberries, oranges, grapes, blackberries, and pineapples, exploding outward with vibrant juice splashes and dynamic motion. Ultra high-definition, extreme sharpness, cinematic lighting with dramatic contrast, rich vivid colors, floating and overlapping fruits, fine textures on fruit surfaces, droplets and splashes frozen in mid-air, luxury food photography style, highly detailed, black background, negative space, visually striking composition, hyper-realistic rendering, ultra-detailed photorealism', 'nano-banana', 'auto', '1:1', '1024x1024', '1K', '', 1, 'deleted', 100, '/profile/upload/2026/05/27/42b96fdb-96c1-4f3a-9fa0-0a662687b3c3.png', '/profile/upload/2026/05/27/42b96fdb-96c1-4f3a-9fa0-0a662687b3c3.png', '用户删除', 15, '2026-05-27 13:45:25', '2026-05-27 13:46:38', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-27 13:45:25', '', '2026-05-28 08:05:49');
INSERT INTO `ai_generation_task` VALUES (83, 103, 'grsai', '小乌龟', 'nano-banana-2', 'auto', '1:1', '1024x1024', '1K', '', 1, 'deleted', 100, '/profile/upload/2026/05/27/ebb4085a-c732-40fd-9b57-2f080a85a864.png', '/profile/upload/2026/05/27/ebb4085a-c732-40fd-9b57-2f080a85a864.png', '用户删除', 12, '2026-05-27 14:33:24', '2026-05-27 14:33:52', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-27 14:33:24', '', '2026-05-28 08:05:46');
INSERT INTO `ai_generation_task` VALUES (84, 103, 'grsai', '小乌龟', 'nano-banana', 'auto', '1:1', '1024x1024', '1K', '', 1, 'deleted', 100, '/profile/upload/2026/05/27/91160e64-76d8-4a1b-81a8-863abb5bcdb7.png', '/profile/upload/2026/05/27/91160e64-76d8-4a1b-81a8-863abb5bcdb7.png', '用户删除', 15, '2026-05-27 14:34:09', '2026-05-27 14:34:24', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-27 14:34:08', '', '2026-05-28 08:05:47');
INSERT INTO `ai_generation_task` VALUES (85, 103, 'grsai', '一架造型现代、流线型设计的客机正平稳地飞行在万米高空，机身表面涂装洁白且富有金属质感，在阳光照射下泛着细腻的光泽。背景是浩瀚无垠的蓝天，由深邃的蔚蓝逐渐过渡到地平线处的淡青色，几缕轻盈的羽状云丝在机身侧后方缓缓延伸。画面采用宏大的广角构图，从侧上方俯瞰的视角捕捉飞机破云而行的动态，强烈的日光从侧后方斜射，在机身侧面勾勒出明亮的轮廓光，同时在机翼下方投下柔和的阴影。画面整体呈现出高清摄影的写实风格，细节极其丰富，机翼边缘的航行灯隐约闪烁，引擎整流罩的金属纹理清晰可见，营造出大气、宏伟且充满科技感的氛围。', 'nano-banana', 'auto', '1:1', '2048x2048', '2K', '', 1, 'success', 100, '/profile/upload/2026/05/28/09669023-69b7-491d-9bdb-8290b026bebf.png', '/profile/upload/2026/05/28/09669023-69b7-491d-9bdb-8290b026bebf.png', NULL, 18, '2026-05-28 09:35:38', '2026-05-28 09:35:47', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 09:35:37', '', '2026-05-28 09:35:50');
INSERT INTO `ai_generation_task` VALUES (86, 103, 'grsai', '一只极其华丽的雄孔雀，全身覆盖着如绸缎般闪烁着金属光泽的羽毛，翠绿色与宝蓝色的羽翎层层叠叠，交织出宝石般的质感。孔雀正处于盛大的开屏状态，巨大的尾屏如同一把半圆形的华丽折扇，每一根羽毛末端都镶嵌着深邃、灵动的眼状斑纹，斑纹中心呈现出如紫水晶般璀璨的虹彩，随着光线的流转不断变换色彩。\n\n画面采用近景构图，焦点清晰地聚集在孔雀高傲优雅的头部，其头顶的冠羽精致如金丝细工，眼神锐利而充满灵气。背景是朦胧且充满诗意的东方园林，淡雅的青石假山与若隐若现的古典花窗作为虚化背景，营造出深邃的空间感。柔和的晨曦穿透薄雾洒在孔雀身上，形成细腻的轮廓光，使得羽毛的纹理更加立体清晰，整体色调华贵典雅，呈现出电影级的写实摄影质感与超高清画质。', 'nano-banana', 'auto', '4:3', '1024x768', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/28/3eaf0c59-5f57-4c68-b9ad-2717ed88310a.png', '/profile/upload/2026/05/28/3eaf0c59-5f57-4c68-b9ad-2717ed88310a.png', NULL, 15, '2026-05-28 09:52:11', '2026-05-28 09:52:24', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 09:52:11', '', '2026-05-28 09:52:30');
INSERT INTO `ai_generation_task` VALUES (87, 103, 'grsai', '一位衣着褴褛、面容沧桑的穷人，身处破旧逼仄的贫民窟巷弄中。他蜷缩在斑驳潮湿的砖墙角落，身上穿着打满补丁、色泽黯淡且布满污垢的粗布衣衫。他眼神深邃而疲惫，流露出对生活的无奈与岁月的磨砺，脸上带着深刻的皱纹和灰尘，皮肤呈现出粗糙的质感。\n\n画面采用低机位近景构图，侧重于刻画人物的神态与生活环境的压抑感。光线昏暗且冷冽，一束微弱、浑浊的自然光从上方狭窄的缝隙中倾泻而下，照亮了他凌乱的发丝和粗糙的脸部轮廓，其余部分则隐没在浓重的阴影中，营造出沉重、压抑且充满叙事感的写实氛围。整体色调偏向冷灰与土褐色，强调真实感、颗粒感与电影级的影像质感。', 'nano-banana', 'auto', 'auto', '', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/28/f88638cf-ab24-4714-bc24-187347790d73.png', '/profile/upload/2026/05/28/f88638cf-ab24-4714-bc24-187347790d73.png', NULL, 15, '2026-05-28 10:05:09', '2026-05-28 10:05:21', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 10:05:08', '', '2026-05-28 10:05:26');
INSERT INTO `ai_generation_task` VALUES (88, 103, 'grsai', '写实摄影风格，低机位近景特写。一位衣着褴褛、面容沧桑的贫民蜷缩在逼仄阴暗的贫民窟巷弄角落。他身上穿着层层叠叠、打满粗糙补丁的麻布衣衫，布料不仅褪色发白，还沾染着厚重的泥垢与油渍，质感粗砺。人物神态深邃疲惫，深刻的皱纹如刀刻般布满脸庞，皮肤粗糙干燥，沾染着零星的灰尘与污垢，双眼流露出历经岁月磨砺后的沉重与无奈。\n\n构图聚焦于人物上半身，背景是斑驳陆离、渗出水渍的砖墙，墙面开裂处露出腐朽的木质结构。环境光线冷冽而昏暗，仅有一束微弱、浑浊的自然光从上方狭窄的巷道缝隙中倾泻而下，精准地勾勒出他凌乱干枯的发丝边缘与凹陷的脸部轮廓，其余躯体则沉浸在厚重的阴影之中，强化了空间的压抑感与孤独感。色调以深沉的冷灰与压抑的土褐色为主，强调胶片摄影的细腻颗粒感，画面呈现出电影级的高对比度叙事氛围，光影层次丰富，极具真实质感。', 'nano-banana', 'auto', 'auto', '', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/28/b05577c6-f2da-4f3b-9a4f-047a47f57695.png', '/profile/upload/2026/05/28/b05577c6-f2da-4f3b-9a4f-047a47f57695.png', NULL, 15, '2026-05-28 10:06:29', '2026-05-28 10:06:41', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 10:06:28', '', '2026-05-28 10:06:47');
INSERT INTO `ai_generation_task` VALUES (89, 103, 'grsai', '苍茫辽阔的古代武侠世界，一位身姿矫健的侠客伫立于险峻孤峰之巅。侠客身着质感细腻的深色长袍，衣袂在凛冽的山风中猎猎作响，腰间悬挂着一柄古朴的长剑，剑鞘上刻有斑驳的岁月纹路。\n\n画面采用宏大的广角构图，展现出群山环抱、云海翻涌的壮丽景象。清晨的第一缕金色阳光穿透厚重的云层，洒在侠客的背影与崎岖的岩石上，形成强烈的光影对比，勾勒出人物坚毅的轮廓。背景中，远山如黛，若隐若现，几只苍鹰在高空盘旋，营造出一种孤高、冷峻而又大气磅礴的武侠意境。\n\n整体画风呈现出电影级的高清质感，色彩沉稳且富有诗意，细节处可见岩石的纹理、衣物的纤维以及空气中漂浮的微尘。光线柔和而具有穿透力，营造出一种超脱世俗、快意恩仇的江湖氛围。', 'nano-banana', 'auto', 'auto', '', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/28/a1d9566f-f58e-46ff-9c7e-536d4cbd94fb.png', '/profile/upload/2026/05/28/a1d9566f-f58e-46ff-9c7e-536d4cbd94fb.png', NULL, 15, '2026-05-28 10:22:48', '2026-05-28 10:23:00', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 10:22:47', '', '2026-05-28 10:23:05');
INSERT INTO `ai_generation_task` VALUES (90, 103, 'grsai', '一位身姿优雅的舞者正在空灵的舞台中央翩翩起舞，身体呈现出极具张力的舒展姿态，轻盈的动作带动着身上半透明的丝绸舞裙，裙摆在空中勾勒出柔和而流动的弧线。背景是深邃且富有层次感的暗调空间，一束冷暖交织的聚光灯从斜上方倾泻而下，精准地捕捉着舞者细腻的肌肤纹理与动作的动态美感。空气中漂浮着细微的尘埃与闪烁的光点，营造出梦幻而静谧的氛围。画面采用电影级的构图，强调光影的明暗对比，呈现出细腻的写实质感，色彩沉稳且富有诗意，展现出极高的艺术表现力。', 'gpt-image-2', 'auto', '1:1', '1024x1024', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/28/6d5b5dec-3543-4ff8-8e7f-11f10eabf814.png', '/profile/upload/2026/05/28/6d5b5dec-3543-4ff8-8e7f-11f10eabf814.png', NULL, 6, '2026-05-28 10:24:42', '2026-05-28 10:25:43', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 10:24:42', '', '2026-05-28 10:25:50');
INSERT INTO `ai_generation_task` VALUES (91, 103, 'grsai', '一位舞者在空旷的舞台中央尽情舞动，身体舒展呈现出优美的曲线，动态感十足，衣袂随着动作轻盈飘逸，捕捉瞬间的优雅姿态。柔和的聚光灯从上方垂直打下，在地面投射出清晰的光圈，背景深邃幽暗，形成强烈的明暗对比。画面采用全景构图，质感细腻，呈现出电影级的艺术摄影风格，光影交织出梦幻且充满力量的氛围。', 'nano-banana', 'auto', '1:1', '', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/28/86e718cf-e758-4c0b-98bf-0d188f510439.png', '/profile/upload/2026/05/28/86e718cf-e758-4c0b-98bf-0d188f510439.png', NULL, 15, '2026-05-28 10:27:56', '2026-05-28 10:28:08', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 10:27:55', '', '2026-05-28 10:28:10');
INSERT INTO `ai_generation_task` VALUES (92, 103, 'grsai', '一位极度饥饿的年轻人坐在昏暗的餐桌前，眼神空洞而渴望地凝视着前方，双手无力地支撑着下巴，面前的餐盘空空如也，只有几粒干瘪的碎屑，背景是虚化的冷色调厨房，柔和的侧逆光勾勒出人物消瘦的轮廓与凌乱的发丝，整体呈现出一种颓废、写实且带有强烈情感张力的电影感画面，细节丰富，光影对比强烈，质感细腻，强调人物内心的饥饿感与环境的荒凉。', 'nano-banana', 'auto', 'auto', '', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/28/713cda80-2d78-4e15-8606-59e75b066eec.png', '/profile/upload/2026/05/28/713cda80-2d78-4e15-8606-59e75b066eec.png', NULL, 15, '2026-05-28 10:40:19', '2026-05-28 10:40:28', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 10:40:18', '', '2026-05-28 10:40:31');
INSERT INTO `ai_generation_task` VALUES (93, 103, 'grsai', '长颈鹿', 'nano-banana', 'auto', 'auto', '', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/28/017a0db0-0abf-45fd-ae23-038011603697.png', '/profile/upload/2026/05/28/017a0db0-0abf-45fd-ae23-038011603697.png', NULL, 15, '2026-05-28 10:42:41', '2026-05-28 10:42:53', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 10:42:41', '', '2026-05-28 10:42:57');
INSERT INTO `ai_generation_task` VALUES (94, 103, 'grsai', '小猪', 'nano-banana', 'auto', 'auto', '', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/28/61309278-671b-4d3f-af73-cf29eecec055.png', '/profile/upload/2026/05/28/61309278-671b-4d3f-af73-cf29eecec055.png', NULL, 15, '2026-05-28 10:52:38', '2026-05-28 10:52:53', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 10:52:37', '', '2026-05-28 10:53:02');
INSERT INTO `ai_generation_task` VALUES (95, 103, 'grsai', '小马', 'nano-banana', 'auto', 'auto', '', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/28/820f59a9-8318-469d-9917-530710501c39.png', '/profile/upload/2026/05/28/820f59a9-8318-469d-9917-530710501c39.png', NULL, 15, '2026-05-28 10:56:22', '2026-05-28 10:56:34', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 10:56:21', '', '2026-05-28 10:56:35');
INSERT INTO `ai_generation_task` VALUES (96, 103, 'grsai', '小马', 'nano-banana', 'auto', 'auto', '', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/28/3bc44fac-e442-46b0-a73d-8285ac14d384.png', '/profile/upload/2026/05/28/3bc44fac-e442-46b0-a73d-8285ac14d384.png', NULL, 15, '2026-05-28 10:56:47', '2026-05-28 10:56:59', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 10:56:46', '', '2026-05-28 10:57:02');
INSERT INTO `ai_generation_task` VALUES (97, 103, 'grsai', '小牛', 'nano-banana', 'auto', 'auto', '', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/28/5a885501-ce8f-48a3-ab5b-9b8329809605.png', '/profile/upload/2026/05/28/5a885501-ce8f-48a3-ab5b-9b8329809605.png', NULL, 15, '2026-05-28 11:07:46', '2026-05-28 11:07:59', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 11:07:46', '', '2026-05-28 11:08:06');
INSERT INTO `ai_generation_task` VALUES (98, 103, 'grsai', '鹦鹉', 'nano-banana', 'auto', '16:9', '', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/28/ec854235-2e33-427e-a1e8-01a94fd85a90.png', '/profile/upload/2026/05/28/ec854235-2e33-427e-a1e8-01a94fd85a90.png', NULL, 15, '2026-05-28 11:28:18', '2026-05-28 11:28:28', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 11:28:18', '', '2026-05-28 11:28:33');
INSERT INTO `ai_generation_task` VALUES (99, 103, 'grsai', '乌鸦', 'nano-banana', 'auto', '4:3', '', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/28/101524ab-0d4a-41d9-8a96-6b7469e25036.png', '/profile/upload/2026/05/28/101524ab-0d4a-41d9-8a96-6b7469e25036.png', NULL, 15, '2026-05-28 11:29:06', '2026-05-28 11:29:15', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 11:29:05', '', '2026-05-28 11:29:20');
INSERT INTO `ai_generation_task` VALUES (100, 103, 'grsai', '乌鸦', 'nano-banana', 'auto', '4:3', '', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/28/1ee26e60-1286-4f25-9f66-888efb41c96c.png', '/profile/upload/2026/05/28/1ee26e60-1286-4f25-9f66-888efb41c96c.png', NULL, 15, '2026-05-28 11:29:29', '2026-05-28 11:29:45', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 11:29:29', '', '2026-05-28 11:29:48');
INSERT INTO `ai_generation_task` VALUES (101, 103, 'grsai', '老虎', 'nano-banana', 'auto', '21:9', '', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/28/7e202b4b-f317-4f7d-b71e-8d59bbb0f665.png', '/profile/upload/2026/05/28/7e202b4b-f317-4f7d-b71e-8d59bbb0f665.png', NULL, 15, '2026-05-28 11:30:42', '2026-05-28 11:30:51', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 11:30:41', '', '2026-05-28 11:30:55');
INSERT INTO `ai_generation_task` VALUES (102, 103, 'grsai', '狮子', 'nano-banana', 'auto', '4:3', '', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/28/28fee157-963a-4f57-8965-a3115c794c23.png', '/profile/upload/2026/05/28/28fee157-963a-4f57-8965-a3115c794c23.png', NULL, 5, '2026-05-28 11:35:25', '2026-05-28 11:35:37', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 11:35:25', '', '2026-05-28 11:35:48');
INSERT INTO `ai_generation_task` VALUES (103, 103, 'grsai', '猎豹', 'nano-banana', 'auto', 'auto', '', '1K', '', 2, 'success', 100, '/profile/upload/2026/05/28/df6ac8ff-6097-4bec-bb67-1d0a121bf4f5.png,/profile/upload/2026/05/28/4fcbf77d-910c-45e8-9a1e-52072f2a81fe.png', '/profile/upload/2026/05/28/df6ac8ff-6097-4bec-bb67-1d0a121bf4f5.png', NULL, 10, '2026-05-28 14:38:55', '2026-05-28 14:39:07', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 14:38:54', '', '2026-05-28 14:39:21');
INSERT INTO `ai_generation_task` VALUES (104, 103, 'grsai', '一头成年河马正半浸在平静的河流中，它巨大的头部浮出水面，湿润的皮肤在阳光下呈现出深灰带粉的质感，皮肤表面的水珠晶莹剔透，能够清晰看到粗糙的纹理。背景是柔和虚化的热带湿地，芦苇和远处的丛林在晨光中呈现出静谧的翠绿色。侧逆光照亮了河马耳廓和背部的轮廓，形成一层淡淡的金边，水面波纹细腻，倒映着天空的色彩，营造出写实、自然且充满生命力的生态摄影风格，画面细节丰富，色彩自然和谐。', 'nano-banana-2', 'auto', '1:8', '256x2048', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/28/56e98435-4ec9-45c2-8887-8272eb8320b7.png', '/profile/upload/2026/05/28/56e98435-4ec9-45c2-8887-8272eb8320b7.png', NULL, 12, '2026-05-28 15:05:20', '2026-05-28 15:05:44', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 15:05:19', '', '2026-05-28 15:05:46');
INSERT INTO `ai_generation_task` VALUES (105, 103, 'grsai', '清澈见底的溪流中，一条灵动优美的鱼儿正悠然游弋，鱼鳞在阳光的穿透下闪烁着如宝石般璀璨的金属光泽，半透明的鱼鳍轻柔摆动，在水中划出细微而优雅的涟漪。水底铺满圆润光滑的鹅卵石，错落有致，几株翠绿的水草随波轻摇。柔和的自然光从水面上方投射下来，在水底形成斑驳灵动的光影。画面采用微距摄影视角，聚焦于鱼儿的身姿，背景呈现出梦幻般的虚化效果，整体色调清幽宁静，质感晶莹剔透，展现出栩栩如生的生态美感。', 'gpt-image-2', 'auto', '4:5', '1120x1408', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/28/ab920af4-383e-4e04-b3bc-6b7b814fbb17.png', '/profile/upload/2026/05/28/ab920af4-383e-4e04-b3bc-6b7b814fbb17.png', NULL, 6, '2026-05-28 17:08:07', '2026-05-28 17:09:02', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 17:08:06', '', '2026-05-28 17:09:03');
INSERT INTO `ai_generation_task` VALUES (106, 103, 'grsai', '一匹骏马伫立在开阔的草原上，全身覆盖着如丝绸般顺滑且富有光泽的棕栗色鬃毛，肌肉线条流畅结实，展现出强健的生命力。马匹正微微侧头，眼神温顺而深邃，鼻翼轻轻翕动。背景是清晨时分，柔和的金色阳光穿透薄雾，洒在马背上，勾勒出明亮的轮廓光。画面采用电影级构图，聚焦于马匹的半身特写，背景是虚化处理的苍翠草地与远处的淡蓝色山峦，营造出宁静、宏大且充满质感的自然意境。超高清画质，细腻的毛发纹理，冷暖色调和谐交融，唯美写实风格。', 'nano-banana', 'auto', '1:1', '', '1K', '', 1, 'success', 100, '/profile/upload/2026/05/28/627c79af-3276-4b81-a30b-ab6830fc919a.png', '/profile/upload/2026/05/28/627c79af-3276-4b81-a30b-ab6830fc919a.png', NULL, 5, '2026-05-28 17:10:11', '2026-05-28 17:10:23', 'wx_oSfJ5V2FCF31A3DBxB2I', '2026-05-28 17:10:10', '', '2026-05-28 17:10:27');

-- ----------------------------
-- Table structure for ai_image_global_config
-- ----------------------------
DROP TABLE IF EXISTS `ai_image_global_config`;
CREATE TABLE `ai_image_global_config`  (
  `config_id` bigint NOT NULL DEFAULT 1 COMMENT '閰嶇疆ID锛屽浐瀹氫负1',
  `circuit_breaker_failure_threshold` int NOT NULL DEFAULT 3 COMMENT '鐔旀柇澶辫触闃堝?',
  `circuit_breaker_cooldown_minutes` int NOT NULL DEFAULT 10 COMMENT '鐔旀柇鍐峰嵈鍒嗛挓',
  `output_format` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'jpeg' COMMENT '杈撳嚭鏍煎紡锛歫peg/png',
  `output_compression` int NOT NULL DEFAULT 90 COMMENT 'JPEG鍘嬬缉寮哄害锛?-100',
  `model_pricings` json NOT NULL COMMENT '妯″瀷鍩虹?绉?垎浠锋牸JSON',
  `resolution_multipliers` json NOT NULL COMMENT '娓呮櫚搴﹀?鐜嘕SON',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '澶囨敞',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '鍒涘缓鑰',
  `create_time` datetime NULL DEFAULT NULL COMMENT '鍒涘缓鏃堕棿',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '鏇存柊鑰',
  `update_time` datetime NULL DEFAULT NULL COMMENT '鏇存柊鏃堕棿',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AI鍥剧墖鍏ㄥ眬閰嶇疆' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_image_global_config
-- ----------------------------
INSERT INTO `ai_image_global_config` VALUES (1, 3, 10, 'jpeg', 90, '[{\"model\": \"gpt-image-2\", \"remark\": \"全能艺术创作\", \"enabled\": true, \"sortOrder\": 1, \"baseCredits\": 6}, {\"model\": \"gpt-image-2-vip\", \"remark\": \"尺寸增强\", \"enabled\": true, \"sortOrder\": 2, \"baseCredits\": 13}, {\"model\": \"nano-banana\", \"remark\": \"轻量快速生成\", \"enabled\": true, \"sortOrder\": 3, \"baseCredits\": 5}, {\"model\": \"nano-banana-2\", \"remark\": \"写实摄影风格\", \"enabled\": true, \"sortOrder\": 4, \"baseCredits\": 12}, {\"model\": \"nano-banana-pro\", \"remark\": \"专业细节增强\", \"enabled\": true, \"sortOrder\": 5, \"baseCredits\": 18}, {\"model\": \"11\", \"remark\": \"1\", \"enabled\": true, \"sortOrder\": 6, \"baseCredits\": 6}]', '{\"1K\": 1.0, \"2K\": 1.2, \"4K\": 1.4}', 'AI生图全局配置', 'admin', '2026-05-28 14:29:48', 'admin', '2026-05-28 20:57:55');

-- ----------------------------
-- Table structure for ai_image_model_route
-- ----------------------------
DROP TABLE IF EXISTS `ai_image_model_route`;
CREATE TABLE `ai_image_model_route`  (
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模型',
  `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `primary_provider_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主通道编码',
  `backup_provider_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备用通道编码',
  `fallback_enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否失败切备用',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`model`) USING BTREE,
  INDEX `fk_ai_image_route_primary`(`primary_provider_code` ASC) USING BTREE,
  INDEX `fk_ai_image_route_backup`(`backup_provider_code` ASC) USING BTREE,
  CONSTRAINT `fk_ai_image_route_backup` FOREIGN KEY (`backup_provider_code`) REFERENCES `ai_image_provider` (`provider_code`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ai_image_route_primary` FOREIGN KEY (`primary_provider_code`) REFERENCES `ai_image_provider` (`provider_code`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AI图片模型路由' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_image_model_route
-- ----------------------------
INSERT INTO `ai_image_model_route` VALUES ('gpt-image-2', 1, 'grsai', NULL, 0, 1, 'GPT 主用 SuperAPI，失败切 Grsai', '2026-05-28 20:57:55', '2026-05-28 20:57:55');
INSERT INTO `ai_image_model_route` VALUES ('gpt-image-2-vip', 1, 'grsai', NULL, 0, 3, '', '2026-05-28 20:57:55', '2026-05-28 20:57:55');
INSERT INTO `ai_image_model_route` VALUES ('nano-banana', 1, 'grsai', NULL, 0, 3, 'nano-banana 暂时走 Grsai', '2026-05-28 20:57:55', '2026-05-28 20:57:55');
INSERT INTO `ai_image_model_route` VALUES ('nano-banana-2', 1, 'grsai', NULL, 0, 2, 'nano-banana 固定走 Grsai', '2026-05-28 20:57:55', '2026-05-28 20:57:55');
INSERT INTO `ai_image_model_route` VALUES ('nano-banana-pro', 1, 'grsai', NULL, 0, 5, 'nano-banana-pro 暂时走 Grsai', '2026-05-28 20:57:55', '2026-05-28 20:57:55');

-- ----------------------------
-- Table structure for ai_image_provider
-- ----------------------------
DROP TABLE IF EXISTS `ai_image_provider`;
CREATE TABLE `ai_image_provider`  (
  `provider_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '通道编码',
  `provider_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '通道名称',
  `adapter_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '接口协议/适配器类型',
  `response_mode` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'json' COMMENT 'OpenAI compatible response mode: json/stream',
  `supports_batch` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否支持单次批量生成',
  `base_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Base URL',
  `api_key` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'API Key',
  `enabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否启用',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`provider_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AI图片通道配置' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_image_provider
-- ----------------------------
INSERT INTO `ai_image_provider` VALUES ('grsai', 'Grsai 中转站', 'grsai-async', 'json', 0, 'https://grsai.dakka.com.cn', 'sk-8bf47400c7774296a2b52b9f24623d95', 1, 2, '支持 GPT 与 nano-banana 的中转站', '2026-05-28 20:57:55', '2026-05-28 20:57:55');
INSERT INTO `ai_image_provider` VALUES ('superapi', 'SuperAPI 中转站', 'openai-compatible', 'stream', 1, 'https://gpt2image.superapi.buzz/v1', 'g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08', 1, 1, '默认 GPT 主通道', '2026-05-28 20:57:55', '2026-05-28 20:57:55');

-- ----------------------------
-- Table structure for ai_image_provider_call_log
-- ----------------------------
DROP TABLE IF EXISTS `ai_image_provider_call_log`;
CREATE TABLE `ai_image_provider_call_log`  (
  `log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `task_id` bigint NOT NULL COMMENT '任务ID',
  `provider_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '通道编码：primary/backup',
  `provider_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '通道名称',
  `model` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '模型',
  `quality` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '质量',
  `size` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '尺寸',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用状态：success/failed',
  `fallback_used` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否备用通道兜底调用',
  `duration_ms` bigint NULL DEFAULT NULL COMMENT '调用耗时毫秒',
  `error_message` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '错误信息',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`log_id`) USING BTREE,
  INDEX `idx_ai_image_call_task`(`task_id` ASC) USING BTREE,
  INDEX `idx_ai_image_call_provider_time`(`provider_code` ASC, `create_time` ASC) USING BTREE,
  INDEX `idx_ai_image_call_status_time`(`status` ASC, `create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 89 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI图片通道调用日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_image_provider_call_log
-- ----------------------------
INSERT INTO `ai_image_provider_call_log` VALUES (1, 15, 'primary', 'GPT2IMAGE主通道', 'gpt-image-2', 'high', '1:1', 'failed', 0, 996, '图片生成失败：{\"error\":{\"message\":\"Invalid image size\",\"type\":\"invalid_request_error\",\"code\":null,\"status\":400}}', '2026-05-23 00:48:53');
INSERT INTO `ai_image_provider_call_log` VALUES (2, 16, 'primary', 'GPT2IMAGE主通道', 'gpt-image-2', 'high', '1:1', 'failed', 0, 732, '图片生成失败：{\"error\":{\"message\":\"Invalid image size\",\"type\":\"invalid_request_error\",\"code\":null,\"status\":400}}', '2026-05-23 00:52:15');
INSERT INTO `ai_image_provider_call_log` VALUES (3, 17, 'primary', 'GPT2IMAGE主通道', 'gpt-image-2', 'high', '1024x1024', 'failed', 0, 64075, '图片生成失败：HTTP/1.1 header parser received no bytes', '2026-05-23 01:01:12');
INSERT INTO `ai_image_provider_call_log` VALUES (4, 18, 'primary', 'GPT2IMAGE主通道', 'gpt-image-2', 'high', '1024x1024', 'failed', 0, 60396, '图片生成失败：HTTP/1.1 header parser received no bytes', '2026-05-23 01:12:03');
INSERT INTO `ai_image_provider_call_log` VALUES (5, 18, 'backup', '备用通道', 'gpt-image-2', 'high', '1024x1024', 'failed', 1, 60422, '图片生成失败：HTTP/1.1 header parser received no bytes', '2026-05-23 01:13:03');
INSERT INTO `ai_image_provider_call_log` VALUES (6, 19, 'primary', 'GPT2IMAGE主通道', 'gpt-image-2', 'high', '1024x1024', 'failed', 0, 1, '图片生成失败：restricted header name: \"Connection\"', '2026-05-23 01:31:07');
INSERT INTO `ai_image_provider_call_log` VALUES (7, 19, 'backup', '备用通道', 'gpt-image-2', 'high', '1024x1024', 'failed', 1, 0, '图片生成失败：restricted header name: \"Connection\"', '2026-05-23 01:31:07');
INSERT INTO `ai_image_provider_call_log` VALUES (8, 20, 'primary', 'GPT2IMAGE主通道', 'gpt-image-2', 'high', '1024x1024', 'failed', 0, 60417, '图片生成响应异常，请稍后到作品中查看', '2026-05-23 01:33:33');
INSERT INTO `ai_image_provider_call_log` VALUES (9, 21, 'primary', 'GPT2IMAGE主通道', 'gpt-image-2', 'high', '2048x2048', 'failed', 0, 60417, '图片生成响应异常，请稍后到作品中查看', '2026-05-23 01:46:54');
INSERT INTO `ai_image_provider_call_log` VALUES (10, 22, 'primary', 'GPT2IMAGE主通道', 'gpt-image-2', 'high', '1024x1024', 'failed', 0, 60387, '图片生成响应异常，本地未收到生成结果，请重试', '2026-05-23 01:59:17');
INSERT INTO `ai_image_provider_call_log` VALUES (11, 23, 'primary', 'GPT2IMAGE主通道', 'gpt-image-2', 'high', '1024x1024', 'failed', 0, 179263, '图片下载失败：400', '2026-05-23 02:07:21');
INSERT INTO `ai_image_provider_call_log` VALUES (12, 24, 'primary', 'GPT2IMAGE主通道', 'gpt-image-2', 'low', '1024x1024', 'success', 0, 63170, NULL, '2026-05-23 02:11:34');
INSERT INTO `ai_image_provider_call_log` VALUES (13, 25, 'primary', 'GPT2IMAGE主通道', 'gpt-image-2', 'low', '1024x1024', 'success', 0, 197473, NULL, '2026-05-23 10:55:13');
INSERT INTO `ai_image_provider_call_log` VALUES (14, 26, 'primary', 'GPT2IMAGE主通道', 'gpt-image-2', 'high', '2048x2048', 'success', 0, 27154, NULL, '2026-05-23 11:00:40');
INSERT INTO `ai_image_provider_call_log` VALUES (15, 27, 'primary', 'GPT2IMAGE主通道', 'gpt-image-2', 'low', '1024x1024', 'success', 0, 14459, NULL, '2026-05-23 11:01:30');
INSERT INTO `ai_image_provider_call_log` VALUES (16, 28, 'primary', 'GPT2IMAGE主通道', 'gpt-image-2', 'low', '1024x1024', 'success', 0, 48054, NULL, '2026-05-23 11:44:42');
INSERT INTO `ai_image_provider_call_log` VALUES (17, 29, 'primary', 'GPT2IMAGE主通道', 'gpt-image-2', 'low', '1024x1024', 'failed', 0, 18461, '生成结果数量不足：期望 2 张，实际 1 张', '2026-05-23 11:58:17');
INSERT INTO `ai_image_provider_call_log` VALUES (18, 29, 'backup', '备用通道', 'gpt-image-2', 'low', '1024x1024', 'failed', 1, 20185, '图片生成失败：invalid URI scheme data', '2026-05-23 11:58:37');
INSERT INTO `ai_image_provider_call_log` VALUES (19, 30, 'primary', 'GPT2IMAGE主通道', 'gpt-image-2', 'low', '1024x1024', 'success', 0, 41916, NULL, '2026-05-23 13:33:12');
INSERT INTO `ai_image_provider_call_log` VALUES (20, 31, 'primary', 'GPT2IMAGE主通道', 'gpt-image-2', 'low', '1024x1024', 'success', 0, 58388, NULL, '2026-05-25 10:30:37');
INSERT INTO `ai_image_provider_call_log` VALUES (21, 38, 'superapi', 'SuperAPI 中转站', 'gpt-image-2', 'medium', '1024x1024', 'failed', 0, 356, '图片生成失败：流式响应连接异常，请重试', '2026-05-25 15:50:19');
INSERT INTO `ai_image_provider_call_log` VALUES (22, 39, 'superapi', 'SuperAPI 中转站', 'gpt-image-2', 'medium', '1024x1024', 'success', 0, 81821, NULL, '2026-05-25 16:02:33');
INSERT INTO `ai_image_provider_call_log` VALUES (23, 40, 'superapi', 'SuperAPI 中转站', 'gpt-image-2', 'medium', '1024x1024', 'failed', 0, 60536, '图片生成响应异常，本地未收到生成结果，请重试', '2026-05-25 16:09:24');
INSERT INTO `ai_image_provider_call_log` VALUES (24, 41, 'superapi', 'SuperAPI 中转站', 'gpt-image-2', 'medium', '1024x1024', 'failed', 0, 60470, '图片生成响应异常，本地未收到生成结果，结果待确认（IOException：HTTP/1.1 header parser received no bytes）', '2026-05-25 16:16:31');
INSERT INTO `ai_image_provider_call_log` VALUES (25, 42, 'superapi', 'SuperAPI 中转站', 'gpt-image-2', 'medium', '1024x1024', 'success', 0, 17557, NULL, '2026-05-25 16:28:54');
INSERT INTO `ai_image_provider_call_log` VALUES (26, 43, 'grsai', 'Grsai 中转站', 'gpt-image-2', 'medium', '1024x1024', 'success', 0, 86886, NULL, '2026-05-25 16:40:46');
INSERT INTO `ai_image_provider_call_log` VALUES (27, 44, 'grsai', 'Grsai 中转站', 'nano-banana-2', 'medium', '1024x1024', 'success', 0, 41051, NULL, '2026-05-25 17:11:33');
INSERT INTO `ai_image_provider_call_log` VALUES (28, 45, 'grsai', 'Grsai 中转站', 'nano-banana-2', 'medium', '1024x1024', 'success', 0, 39320, NULL, '2026-05-25 17:17:45');
INSERT INTO `ai_image_provider_call_log` VALUES (29, 46, 'grsai', 'Grsai 中转站', 'gpt-image-2', 'low', '1024x1024', 'success', 0, 54891, NULL, '2026-05-26 01:38:49');
INSERT INTO `ai_image_provider_call_log` VALUES (30, 47, 'grsai', 'Grsai 中转站', 'gpt-image-2-vip', 'medium', '2048x2048', 'failed', 0, 3149, '图片生成失败：gpt-image-2-vip model does not support 1:1 parameter, please use pixel value input, for example: 1024x1024', '2026-05-26 01:41:02');
INSERT INTO `ai_image_provider_call_log` VALUES (31, 48, 'grsai', 'Grsai 中转站', 'gpt-image-2-vip', 'auto', '2048x2048', 'failed', 0, 14381, '图片生成失败：gpt-image-2-vip model does not support 1:1 parameter, please use pixel value input, for example: 1024x1024', '2026-05-26 01:47:57');
INSERT INTO `ai_image_provider_call_log` VALUES (32, 49, 'grsai', 'Grsai 中转站', 'gpt-image-2-vip', 'auto', '1024x1024', 'failed', 0, 3141, '图片生成失败：gpt-image-2-vip model does not support 1:1 parameter, please use pixel value input, for example: 1024x1024', '2026-05-26 01:49:10');
INSERT INTO `ai_image_provider_call_log` VALUES (33, 50, 'grsai', 'Grsai 中转站', 'gpt-image-2-vip', 'auto', '2048x2048', 'success', 0, 40398, NULL, '2026-05-26 01:51:05');
INSERT INTO `ai_image_provider_call_log` VALUES (34, 51, 'grsai', 'Grsai 中转站', 'gpt-image-2-vip', 'auto', '2240x1792', 'success', 0, 66847, NULL, '2026-05-26 01:54:13');
INSERT INTO `ai_image_provider_call_log` VALUES (35, 52, 'grsai', 'Grsai 中转站', 'gpt-image-2-vip', 'auto', '1024x1024', 'success', 0, 41998, NULL, '2026-05-26 02:05:21');
INSERT INTO `ai_image_provider_call_log` VALUES (36, 53, 'superapi', 'SuperAPI 中转站', 'gpt-image-2-vip', 'auto', '1024x1024', 'failed', 0, 166, '图片生成失败：流式响应连接异常（ConnectException：无详细信息），请重试', '2026-05-26 19:20:46');
INSERT INTO `ai_image_provider_call_log` VALUES (37, 54, 'grsai', 'Grsai 中转站', 'gpt-image-2-vip', 'auto', '1024x1024', 'failed', 0, 141485, '生成超时，请稍后重试', '2026-05-26 19:24:05');
INSERT INTO `ai_image_provider_call_log` VALUES (38, 55, 'grsai', 'Grsai 中转站', 'gpt-image-2', 'auto', '1024x1024', 'success', 0, 83348, NULL, '2026-05-26 22:11:27');
INSERT INTO `ai_image_provider_call_log` VALUES (39, 56, 'superapi', 'SuperAPI 中转站', 'gpt-image-2', 'auto', '1024x1024', 'failed', 0, 1557, '图片生成失败：图片生成失败：流式响应连接异常（ConnectException：无详细信息），请重试；图片生成失败：流式响应连接异常（ConnectException：无详细信息），请重试', '2026-05-26 22:13:37');
INSERT INTO `ai_image_provider_call_log` VALUES (40, 57, 'superapi', 'SuperAPI 中转站', 'gpt-image-2', 'auto', '1024x1024', 'failed', 0, 65, '图片生成失败：流式响应连接异常（ConnectException：无详细信息），请重试', '2026-05-26 22:17:30');
INSERT INTO `ai_image_provider_call_log` VALUES (41, 58, 'superapi', 'SuperAPI 中转站', 'gpt-image-2', 'auto', '1024x1024', 'failed', 0, 3, '图片生成失败：流式响应连接异常（ConnectException：无详细信息），请重试', '2026-05-26 22:17:39');
INSERT INTO `ai_image_provider_call_log` VALUES (42, 59, 'superapi', 'SuperAPI 中转站', 'gpt-image-2', 'auto', '1024x1024', 'failed', 0, 7, '图片生成失败：流式响应连接异常（ConnectException：无详细信息），请重试', '2026-05-26 22:18:05');
INSERT INTO `ai_image_provider_call_log` VALUES (43, 60, 'superapi', 'SuperAPI 中转站', 'gpt-image-2', 'auto', '1024x1024', 'failed', 0, 49, '图片生成失败：流式响应连接异常（ConnectException：无详细信息），请重试', '2026-05-26 22:20:31');
INSERT INTO `ai_image_provider_call_log` VALUES (44, 61, 'superapi', 'SuperAPI 中转站', 'gpt-image-2', 'auto', '1024x1024', 'failed', 0, 2, '图片生成失败：null', '2026-05-26 22:21:02');
INSERT INTO `ai_image_provider_call_log` VALUES (45, 62, 'superapi', 'SuperAPI 中转站', 'gpt-image-2', 'auto', '1024x1024', 'failed', 0, 2, '图片生成失败：null', '2026-05-26 22:21:08');
INSERT INTO `ai_image_provider_call_log` VALUES (46, 63, 'superapi', 'SuperAPI 中转站', 'gpt-image-2', 'auto', '1024x1024', 'failed', 0, 2, '图片生成失败：null', '2026-05-26 22:21:14');
INSERT INTO `ai_image_provider_call_log` VALUES (47, 64, 'superapi', 'SuperAPI 中转站', 'gpt-image-2', 'auto', '1024x1024', 'failed', 0, 2, '图片生成失败：null', '2026-05-26 22:21:17');
INSERT INTO `ai_image_provider_call_log` VALUES (48, 65, 'grsai', 'Grsai 中转站', 'gpt-image-2', 'auto', '1024x1024', 'failed', 1, 79981, '生成结果数量不足：期望 2 张，实际 1 张', '2026-05-26 22:23:01');
INSERT INTO `ai_image_provider_call_log` VALUES (49, 66, 'superapi', 'SuperAPI 中转站', 'gpt-image-2', 'auto', '1024x1024', 'failed', 0, 56, '图片生成失败：null', '2026-05-26 22:36:07');
INSERT INTO `ai_image_provider_call_log` VALUES (50, 67, 'superapi', 'SuperAPI 中转站', 'gpt-image-2', 'auto', '1024x1024', 'failed', 0, 2, '图片生成失败：流式响应连接异常（ConnectException：无详细信息），请重试', '2026-05-26 22:36:22');
INSERT INTO `ai_image_provider_call_log` VALUES (51, 68, 'superapi', 'SuperAPI 中转站', 'gpt-image-2', 'auto', '1024x1024', 'failed', 0, 1027, '图片生成失败：流式响应连接异常（ConnectException：无详细信息），请重试', '2026-05-26 22:45:06');
INSERT INTO `ai_image_provider_call_log` VALUES (52, 69, 'superapi', 'SuperAPI 中转站', 'gpt-image-2', 'auto', '1024x1024', 'failed', 0, 1024, '图片生成失败：流式响应连接异常（ConnectException：无详细信息），请重试', '2026-05-26 22:47:55');
INSERT INTO `ai_image_provider_call_log` VALUES (53, 70, 'superapi', 'SuperAPI 中转站', 'gpt-image-2', 'auto', '1024x1024', 'failed', 0, 2337, '图片生成失败：流式响应连接异常（SSLHandshakeException：Remote host terminated the handshake），请重试', '2026-05-26 22:55:54');
INSERT INTO `ai_image_provider_call_log` VALUES (54, 71, 'superapi', 'SuperAPI 中转站', 'gpt-image-2', 'auto', '1024x1024', 'success', 0, 101890, NULL, '2026-05-26 23:01:12');
INSERT INTO `ai_image_provider_call_log` VALUES (55, 72, 'grsai', 'Grsai 中转站', 'gpt-image-2', 'auto', '1024x1024', 'success', 0, 99549, NULL, '2026-05-26 23:46:57');
INSERT INTO `ai_image_provider_call_log` VALUES (56, 73, 'grsai', 'Grsai 中转站', 'gpt-image-2', 'auto', '1024x1024', 'success', 0, 72911, NULL, '2026-05-26 23:55:17');
INSERT INTO `ai_image_provider_call_log` VALUES (57, 75, 'grsai', 'Grsai 中转站', 'gpt-image-2', 'auto', '1024x1024', 'failed', 0, 20311, '图片生成失败：We are sorry, but the images we created may have violated our relevant policies. If you think we made a mistake, please try again or edit your prompt.', '2026-05-27 00:13:45');
INSERT INTO `ai_image_provider_call_log` VALUES (58, 76, 'grsai', 'Grsai 中转站', 'gpt-image-2', 'auto', '1024x1024', 'failed', 0, 17312, '图片生成失败：We are sorry, but the images we created may have violated our relevant policies. If you think we made a mistake, please try again or edit your prompt.', '2026-05-27 00:14:30');
INSERT INTO `ai_image_provider_call_log` VALUES (59, 77, 'grsai', 'Grsai 中转站', 'gpt-image-2', 'auto', '1024x1024', 'success', 0, 66577, NULL, '2026-05-27 00:16:01');
INSERT INTO `ai_image_provider_call_log` VALUES (60, 78, 'grsai', 'Grsai 中转站', 'gpt-image-2', 'auto', '1024x1024', 'success', 0, 89531, NULL, '2026-05-27 00:33:44');
INSERT INTO `ai_image_provider_call_log` VALUES (61, 79, 'grsai', 'Grsai 中转站', 'gpt-image-2', 'auto', '1024x1024', 'success', 0, 62261, NULL, '2026-05-27 00:35:23');
INSERT INTO `ai_image_provider_call_log` VALUES (62, 80, 'grsai', 'Grsai 中转站', 'nano-banana-pro', 'auto', '1024x1024', 'success', 0, 58019, NULL, '2026-05-27 11:57:30');
INSERT INTO `ai_image_provider_call_log` VALUES (63, 81, 'grsai', 'Grsai 中转站', 'nano-banana-2', 'auto', '1024x1024', 'success', 0, 27656, NULL, '2026-05-27 11:59:35');
INSERT INTO `ai_image_provider_call_log` VALUES (64, 82, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '1024x1024', 'success', 0, 73031, NULL, '2026-05-27 13:46:38');
INSERT INTO `ai_image_provider_call_log` VALUES (65, 83, 'grsai', 'Grsai 中转站', 'nano-banana-2', 'auto', '1024x1024', 'success', 0, 27617, NULL, '2026-05-27 14:33:52');
INSERT INTO `ai_image_provider_call_log` VALUES (66, 84, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '1024x1024', 'success', 0, 15375, NULL, '2026-05-27 14:34:24');
INSERT INTO `ai_image_provider_call_log` VALUES (67, 85, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '2048x2048', 'success', 0, 9201, NULL, '2026-05-28 09:35:46');
INSERT INTO `ai_image_provider_call_log` VALUES (68, 86, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '1024x768', 'success', 0, 12284, NULL, '2026-05-28 09:52:23');
INSERT INTO `ai_image_provider_call_log` VALUES (69, 87, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '', 'success', 0, 12271, NULL, '2026-05-28 10:05:20');
INSERT INTO `ai_image_provider_call_log` VALUES (70, 88, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '', 'success', 0, 12324, NULL, '2026-05-28 10:06:41');
INSERT INTO `ai_image_provider_call_log` VALUES (71, 89, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '', 'success', 0, 12292, NULL, '2026-05-28 10:23:00');
INSERT INTO `ai_image_provider_call_log` VALUES (72, 90, 'grsai', 'Grsai 中转站', 'gpt-image-2', 'auto', '1024x1024', 'success', 0, 61038, NULL, '2026-05-28 10:25:43');
INSERT INTO `ai_image_provider_call_log` VALUES (73, 91, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '', 'success', 0, 12215, NULL, '2026-05-28 10:28:07');
INSERT INTO `ai_image_provider_call_log` VALUES (74, 92, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '', 'success', 0, 9212, NULL, '2026-05-28 10:40:28');
INSERT INTO `ai_image_provider_call_log` VALUES (75, 93, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '', 'success', 0, 12300, NULL, '2026-05-28 10:42:53');
INSERT INTO `ai_image_provider_call_log` VALUES (76, 94, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '', 'success', 0, 15311, NULL, '2026-05-28 10:52:53');
INSERT INTO `ai_image_provider_call_log` VALUES (77, 95, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '', 'success', 0, 12356, NULL, '2026-05-28 10:56:33');
INSERT INTO `ai_image_provider_call_log` VALUES (78, 96, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '', 'success', 0, 12237, NULL, '2026-05-28 10:56:59');
INSERT INTO `ai_image_provider_call_log` VALUES (79, 97, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '', 'success', 0, 12342, NULL, '2026-05-28 11:07:58');
INSERT INTO `ai_image_provider_call_log` VALUES (80, 98, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '', 'success', 0, 9307, NULL, '2026-05-28 11:28:27');
INSERT INTO `ai_image_provider_call_log` VALUES (81, 99, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '', 'success', 0, 9292, NULL, '2026-05-28 11:29:14');
INSERT INTO `ai_image_provider_call_log` VALUES (82, 100, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '', 'success', 0, 15359, NULL, '2026-05-28 11:29:44');
INSERT INTO `ai_image_provider_call_log` VALUES (83, 101, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '', 'success', 0, 9246, NULL, '2026-05-28 11:30:51');
INSERT INTO `ai_image_provider_call_log` VALUES (84, 102, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '', 'success', 0, 12241, NULL, '2026-05-28 11:35:37');
INSERT INTO `ai_image_provider_call_log` VALUES (85, 103, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '', 'success', 0, 12490, NULL, '2026-05-28 14:39:07');
INSERT INTO `ai_image_provider_call_log` VALUES (86, 104, 'grsai', 'Grsai 中转站', 'nano-banana-2', 'auto', '256x2048', 'success', 0, 24441, NULL, '2026-05-28 15:05:44');
INSERT INTO `ai_image_provider_call_log` VALUES (87, 105, 'grsai', 'Grsai 中转站', 'gpt-image-2', 'auto', '1120x1408', 'success', 0, 54980, NULL, '2026-05-28 17:09:01');
INSERT INTO `ai_image_provider_call_log` VALUES (88, 106, 'grsai', 'Grsai 中转站', 'nano-banana', 'auto', '', 'success', 0, 12325, NULL, '2026-05-28 17:10:23');

-- ----------------------------
-- Table structure for ai_image_provider_model
-- ----------------------------
DROP TABLE IF EXISTS `ai_image_provider_model`;
CREATE TABLE `ai_image_provider_model`  (
  `provider_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '通道编码',
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模型',
  `provider_model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '供应商实际模型',
  `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `create_time` datetime NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`provider_code`, `model`) USING BTREE,
  CONSTRAINT `fk_ai_image_provider_model_provider` FOREIGN KEY (`provider_code`) REFERENCES `ai_image_provider` (`provider_code`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AI图片通道支持模型' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_image_provider_model
-- ----------------------------
INSERT INTO `ai_image_provider_model` VALUES ('grsai', 'gpt-image-2', 'gpt-image-2', 1, '2026-05-28 20:57:55', '2026-05-28 20:57:55');
INSERT INTO `ai_image_provider_model` VALUES ('grsai', 'gpt-image-2-vip', 'gpt-image-2-vip', 1, '2026-05-28 20:57:55', '2026-05-28 20:57:55');
INSERT INTO `ai_image_provider_model` VALUES ('grsai', 'nano-banana', 'nano-banana-fast', 1, '2026-05-28 20:57:55', '2026-05-28 20:57:55');
INSERT INTO `ai_image_provider_model` VALUES ('grsai', 'nano-banana-2', 'nano-banana-2', 1, '2026-05-28 20:57:55', '2026-05-28 20:57:55');
INSERT INTO `ai_image_provider_model` VALUES ('grsai', 'nano-banana-pro', 'nano-banana-pro', 1, '2026-05-28 20:57:55', '2026-05-28 20:57:55');
INSERT INTO `ai_image_provider_model` VALUES ('superapi', 'gpt-image-2', 'gpt-image-2', 1, '2026-05-28 20:57:55', '2026-05-28 20:57:55');

-- ----------------------------
-- Table structure for ai_invite_record
-- ----------------------------
DROP TABLE IF EXISTS `ai_invite_record`;
CREATE TABLE `ai_invite_record`  (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '邀请记录ID',
  `inviter_user_id` bigint NOT NULL COMMENT '邀请人用户ID',
  `invited_user_id` bigint NOT NULL COMMENT '被邀请人用户ID',
  `reward_amount` int NOT NULL COMMENT '奖励积分',
  `reward_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GRANTED' COMMENT '奖励状态',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`record_id`) USING BTREE,
  UNIQUE INDEX `uk_ai_invite_invited`(`invited_user_id` ASC) USING BTREE,
  INDEX `idx_ai_invite_inviter_time`(`inviter_user_id` ASC, `create_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '邀请奖励记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_invite_record
-- ----------------------------

-- ----------------------------
-- Table structure for ai_payment_order
-- ----------------------------
DROP TABLE IF EXISTS `ai_payment_order`;
CREATE TABLE `ai_payment_order`  (
  `order_id` bigint NOT NULL AUTO_INCREMENT COMMENT '支付订单ID',
  `out_trade_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商户订单号',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `product_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品ID',
  `product_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品类型 MEMBERSHIP/ADDON',
  `product_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品名称',
  `amount_cent` int NOT NULL COMMENT '支付金额，单位分',
  `credits` int NOT NULL COMMENT '到账积分',
  `member_tier` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '会员等级',
  `member_days` int NULL DEFAULT NULL COMMENT '会员天数',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'CREATED' COMMENT '订单状态 CREATED/PAID/CLOSED',
  `transaction_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '微信支付订单号',
  `prepay_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '预支付交易会话ID',
  `paid_time` datetime NULL DEFAULT NULL COMMENT '支付成功时间',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '订单过期时间',
  `notify_time` datetime NULL DEFAULT NULL COMMENT '回调时间',
  `raw_notify` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '回调解密报文',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`order_id`) USING BTREE,
  UNIQUE INDEX `uk_ai_payment_order_trade_no`(`out_trade_no` ASC) USING BTREE,
  INDEX `idx_ai_payment_order_user_time`(`user_id` ASC, `create_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '支付订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_payment_order
-- ----------------------------

-- ----------------------------
-- Table structure for ai_template
-- ----------------------------
DROP TABLE IF EXISTS `ai_template`;
CREATE TABLE `ai_template`  (
  `template_id` bigint NOT NULL AUTO_INCREMENT COMMENT '模板ID',
  `category_id` bigint NOT NULL COMMENT '分类ID',
  `title` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模板标题',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '描述',
  `cover_url` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '封面图URL',
  `prompt` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '提示词',
  `ai_engine` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT 'AI引擎',
  `ratio` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '画幅比例',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`template_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '生图模板表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_template
-- ----------------------------
INSERT INTO `ai_template` VALUES (2, 2, '深墨之妙', '有机水墨质感', 'https://lh3.googleusercontent.com/aida-public/AB6AXuBy4Q9qzhm5vU8r8SAi7IiqgHBba2f1v9frjXOycyfWXX6vCQc4OZgvCJVa8uRoqk_wBWQB1jEe-TP7w1qna1bo_nmz51GR9DyemGINyF8YWag-aKtwur1m5QjuojukeXFL3yKVD_bSs9Gw9WURfyY2WQ3pgIp2u0NHtFZc7bBpG22O-KUhWxhvapU72CV4OlqbFLilBazCO3u0ZoJC0cCD09ggyxU1QgMn2rFE8QvDS_dPMgawbYdKGa7Cyt9RSyvOpC4KNcQpKj4_', 'Organic black ink textures blooming on handmade paper, layered washes, abstract natural forms, elegant Chinese ink painting mood, high contrast, refined composition.', 'V2.4 模型', '1:1', 2, '0', 'admin', '2026-05-19 01:20:05', '', NULL, NULL);
INSERT INTO `ai_template` VALUES (5, 1, '暮色长廊', '暖色建筑街景', 'https://picsum.photos/seed/aipaint-template-5/800/1200', 'Warm dusk corridor, cinematic architecture, soft reflections, quiet urban mood, elegant perspective, premium editorial realism.', 'V2.4 模型', '3:4', 5, '0', 'admin', '2026-05-19 01:20:05', '', NULL, NULL);
INSERT INTO `ai_template` VALUES (6, 2, '云山墨境', '留白山水', 'https://picsum.photos/seed/aipaint-template-6/800/1000', 'Ink-wash mountain clouds, flowing mist, layered paper texture, elegant negative space, poetic Chinese landscape painting.', 'V2.4 模型', '4:5', 6, '0', 'admin', '2026-05-19 01:20:05', '', NULL, NULL);
INSERT INTO `ai_template` VALUES (7, 3, '霓虹深海', '赛博海洋奇观', 'https://picsum.photos/seed/aipaint-template-7/800/1400', 'Neon deep sea world, luminous currents, surreal coral forms, reflective particles, atmospheric cyber fantasy, high contrast.', 'V2.4 模型', '9:16', 7, '0', 'admin', '2026-05-19 01:20:05', '', NULL, NULL);
INSERT INTO `ai_template` VALUES (8, 1, '白昼纸雕', '纸艺层叠视觉', 'https://picsum.photos/seed/aipaint-template-8/800/800', 'Paper cutout sculpture, bright daylight, layered shadows, handcrafted depth, clean composition, modern minimal design.', 'V2.4 模型', '1:1', 8, '0', 'admin', '2026-05-19 01:20:05', '', NULL, NULL);
INSERT INTO `ai_template` VALUES (9, 2, '青黛远岸', '水墨远景', 'https://picsum.photos/seed/aipaint-template-9/800/1200', 'Ink tone distant shore, layered horizons, calm atmosphere, soft gradients, refined oriental landscape, contemplative mood.', 'V2.4 模型', '16:9', 9, '0', 'admin', '2026-05-19 01:20:05', '', NULL, NULL);
INSERT INTO `ai_template` VALUES (10, 3, '未来街区', '赛博城市夜景', 'https://picsum.photos/seed/aipaint-template-10/800/1100', 'Futuristic city blocks, glowing signage, layered neon streets, high detail, cinematic depth, premium sci-fi concept art.', 'V2.4 模型', '3:4', 10, '0', 'admin', '2026-05-19 01:20:05', '', NULL, NULL);
INSERT INTO `ai_template` VALUES (11, 1, '静谧展厅', '现代空间陈列', 'https://picsum.photos/seed/aipaint-template-11/800/1000', 'Quiet exhibition hall, clean product display, soft daylight, refined interior composition, minimal contemporary aesthetic.', 'V2.4 模型', '4:5', 11, '0', 'admin', '2026-05-19 01:20:05', '', NULL, NULL);
INSERT INTO `ai_template` VALUES (12, 2, '墨桥回声', '桥景与墨韵', 'https://picsum.photos/seed/aipaint-template-12/800/800', 'Ink bridge silhouette, reflective water, gentle brushwork, atmospheric mist, poetic modern Chinese art direction.', 'V2.4 模型', '1:1', 12, '0', 'admin', '2026-05-19 01:20:05', '', NULL, NULL);
INSERT INTO `ai_template` VALUES (100, 100, '限量球鞋发售海报悬浮火焰背景', '', '/profile/upload/2026/05/21/opennana-14302-0_20260521011246A001.jpg', 'Limited edition sneaker release poster, sneakers levitating in mid-air, flame special effects background', 'GPT image2', '3:4', 0, '0', 'admin', '2026-05-21 01:13:03', 'admin', '2026-05-29 01:16:57', NULL);

-- ----------------------------
-- Table structure for ai_template_category
-- ----------------------------
DROP TABLE IF EXISTS `ai_template_category`;
CREATE TABLE `ai_template_category`  (
  `category_id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `category_name` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称',
  `category_code` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类编码',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`category_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 104 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '生图模板分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_template_category
-- ----------------------------
INSERT INTO `ai_template_category` VALUES (1, '极简主义', 'minimal', 1, '0', 'admin', '2026-05-19 01:20:05', '', NULL, NULL);
INSERT INTO `ai_template_category` VALUES (2, '水墨艺术', 'ink', 2, '0', 'admin', '2026-05-19 01:20:05', '', NULL, NULL);
INSERT INTO `ai_template_category` VALUES (3, '超现实', 'surreal', 3, '0', 'admin', '2026-05-19 01:20:05', '', NULL, NULL);
INSERT INTO `ai_template_category` VALUES (100, '海报与营销', 'poster_marketing', 4, '0', 'admin', '2026-05-21 01:03:34', '', NULL, NULL);
INSERT INTO `ai_template_category` VALUES (101, '食物', 'food', 5, '0', 'admin', '2026-05-21 01:03:34', '', NULL, NULL);
INSERT INTO `ai_template_category` VALUES (102, '动漫', 'anime', 6, '0', 'admin', '2026-05-21 01:03:34', '', NULL, NULL);
INSERT INTO `ai_template_category` VALUES (103, '产品与广告', 'product_advertising', 7, '0', 'admin', '2026-05-21 01:03:34', '', NULL, NULL);

-- ----------------------------
-- Table structure for ai_template_tag
-- ----------------------------
DROP TABLE IF EXISTS `ai_template_tag`;
CREATE TABLE `ai_template_tag`  (
  `tag_id` bigint NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `tag_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标签名称',
  `group_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分组编码(style/use/subject/element)',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`tag_id`) USING BTREE,
  UNIQUE INDEX `uk_ai_template_tag_name_group`(`tag_name` ASC, `group_code` ASC) USING BTREE,
  INDEX `idx_ai_template_tag_group_status_sort`(`group_code` ASC, `status` ASC, `sort` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '生图模板标签表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_template_tag
-- ----------------------------
INSERT INTO `ai_template_tag` VALUES (1, '极简', 'style', 1, '0', 'admin', '2026-05-29 01:00:24', '', NULL, NULL);
INSERT INTO `ai_template_tag` VALUES (2, '水墨', 'style', 2, '0', 'admin', '2026-05-29 01:00:24', '', NULL, NULL);
INSERT INTO `ai_template_tag` VALUES (3, '超现实', 'style', 3, '0', 'admin', '2026-05-29 01:00:24', '', NULL, NULL);
INSERT INTO `ai_template_tag` VALUES (4, '海报营销', 'use', 1, '0', 'admin', '2026-05-29 01:00:24', '', NULL, NULL);
INSERT INTO `ai_template_tag` VALUES (5, '电商主图', 'use', 2, '0', 'admin', '2026-05-29 01:00:24', '', NULL, NULL);
INSERT INTO `ai_template_tag` VALUES (6, '球鞋', 'subject', 1, '0', 'admin', '2026-05-29 01:00:24', '', NULL, NULL);
INSERT INTO `ai_template_tag` VALUES (7, '火焰', 'element', 1, '0', 'admin', '2026-05-29 01:00:24', '', NULL, NULL);

-- ----------------------------
-- Table structure for ai_template_tag_relation
-- ----------------------------
DROP TABLE IF EXISTS `ai_template_tag_relation`;
CREATE TABLE `ai_template_tag_relation`  (
  `template_id` bigint NOT NULL COMMENT '模板ID',
  `tag_id` bigint NOT NULL COMMENT '标签ID',
  PRIMARY KEY (`template_id`, `tag_id`) USING BTREE,
  INDEX `idx_ai_template_tag_relation_tag`(`tag_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '生图模板标签关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_template_tag_relation
-- ----------------------------
INSERT INTO `ai_template_tag_relation` VALUES (100, 4);
INSERT INTO `ai_template_tag_relation` VALUES (100, 5);

-- ----------------------------
-- Table structure for ai_user_membership
-- ----------------------------
DROP TABLE IF EXISTS `ai_user_membership`;
CREATE TABLE `ai_user_membership`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `member_tier` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '会员等级 monthly/pro/studio',
  `addon_bonus` int NOT NULL DEFAULT 0 COMMENT '积分加量包加赠百分比',
  `expire_time` datetime NOT NULL COMMENT '会员到期时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户会员表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_user_membership
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `form_col_num` int NULL DEFAULT 1 COMMENT '表单布局（单列 双列 三列）',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '日历信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '已触发的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '任务详细信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '暂停的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '调度器状态表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name` ASC, `job_name` ASC, `job_group` ASC) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '触发器详细信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 123 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '参数配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2026-05-15 00:09:39', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2026-05-15 00:09:39', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2026-05-15 00:09:39', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2026-05-15 00:09:39', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2026-05-15 00:09:39', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2026-05-15 00:09:39', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '1', 'Y', 'admin', '2026-05-15 00:09:39', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2026-05-15 00:09:39', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (9, '用户管理-密码字符范围', 'sys.account.chrtype', '0', 'Y', 'admin', '2026-05-15 00:09:39', '', NULL, '默认任意字符范围，0任意（密码可以输入任意字符），1数字（密码只能为0-9数字），2英文字母（密码只能为a-z和A-Z字母），3字母和数字（密码必须包含字母，数字）,4字母数字和特殊字符（目前支持的特殊字符包括：~!@#$%^&*()-=_+）');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '若依科技', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-15 00:09:39', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-15 00:09:39', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-15 00:09:39', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-15 00:09:39', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-15 00:09:39', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-15 00:09:39', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-15 00:09:39', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-15 00:09:39', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-15 00:09:39', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-05-15 00:09:39', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '停用状态');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '登录状态列表');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2026-05-15 00:09:40', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2026-05-15 00:09:40', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2026-05-15 00:09:40', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '异常信息',
  `start_time` datetime NULL DEFAULT NULL COMMENT '执行开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '执行结束时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 149 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统访问记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-15 01:17:22');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-17 01:30:14');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码错误', '2026-05-18 23:27:37');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 23:27:38');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-19 00:44:25');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 00:44:28');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 20:25:25');
INSERT INTO `sys_logininfor` VALUES (107, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 22:34:41');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-21 00:36:28');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-21 23:15:10');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码错误', '2026-05-22 01:19:40');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-22 01:19:41');
INSERT INTO `sys_logininfor` VALUES (112, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-22 20:31:09');
INSERT INTO `sys_logininfor` VALUES (113, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-22 21:10:47');
INSERT INTO `sys_logininfor` VALUES (114, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-22 22:14:01');
INSERT INTO `sys_logininfor` VALUES (115, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-23 00:40:50');
INSERT INTO `sys_logininfor` VALUES (116, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码错误', '2026-05-23 09:06:46');
INSERT INTO `sys_logininfor` VALUES (117, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-23 09:06:49');
INSERT INTO `sys_logininfor` VALUES (118, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-23 11:05:59');
INSERT INTO `sys_logininfor` VALUES (119, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-25 11:26:00');
INSERT INTO `sys_logininfor` VALUES (120, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-25 13:38:08');
INSERT INTO `sys_logininfor` VALUES (121, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-25 14:41:23');
INSERT INTO `sys_logininfor` VALUES (122, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-25 15:43:58');
INSERT INTO `sys_logininfor` VALUES (123, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-26 01:35:51');
INSERT INTO `sys_logininfor` VALUES (124, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-26 19:18:40');
INSERT INTO `sys_logininfor` VALUES (125, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-26 22:09:12');
INSERT INTO `sys_logininfor` VALUES (126, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-26 23:40:46');
INSERT INTO `sys_logininfor` VALUES (127, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-27 01:21:57');
INSERT INTO `sys_logininfor` VALUES (128, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-27 11:16:42');
INSERT INTO `sys_logininfor` VALUES (129, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-27 11:56:43');
INSERT INTO `sys_logininfor` VALUES (130, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-27 16:07:35');
INSERT INTO `sys_logininfor` VALUES (131, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-28 09:31:57');
INSERT INTO `sys_logininfor` VALUES (132, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-28 13:31:36');
INSERT INTO `sys_logininfor` VALUES (133, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-28 15:26:23');
INSERT INTO `sys_logininfor` VALUES (134, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-28 16:23:02');
INSERT INTO `sys_logininfor` VALUES (135, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-28 20:35:16');
INSERT INTO `sys_logininfor` VALUES (136, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-29 01:01:03');
INSERT INTO `sys_logininfor` VALUES (137, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-29 01:03:02');
INSERT INTO `sys_logininfor` VALUES (138, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-29 01:03:04');
INSERT INTO `sys_logininfor` VALUES (139, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-29 01:03:36');
INSERT INTO `sys_logininfor` VALUES (140, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码错误', '2026-05-29 01:03:38');
INSERT INTO `sys_logininfor` VALUES (141, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-29 01:03:40');
INSERT INTO `sys_logininfor` VALUES (142, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-29 01:05:54');
INSERT INTO `sys_logininfor` VALUES (143, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-29 01:05:56');
INSERT INTO `sys_logininfor` VALUES (144, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-29 01:06:27');
INSERT INTO `sys_logininfor` VALUES (145, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-29 01:06:32');
INSERT INTO `sys_logininfor` VALUES (146, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码已失效', '2026-05-29 08:25:42');
INSERT INTO `sys_logininfor` VALUES (147, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-29 08:25:43');
INSERT INTO `sys_logininfor` VALUES (148, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-29 16:56:39');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2015 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2026-05-15 00:09:39', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2026-05-15 00:09:39', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2026-05-15 00:09:39', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '若依官网', 0, 4, 'http://ruoyi.vip', NULL, '', '', 0, 0, 'M', '0', '0', '', 'guide', 'admin', '2026-05-15 00:09:39', '', NULL, '若依官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2026-05-15 00:09:39', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2026-05-15 00:09:39', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2026-05-15 00:09:39', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2026-05-15 00:09:39', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2026-05-15 00:09:39', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2026-05-15 00:09:39', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2026-05-15 00:09:39', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2026-05-15 00:09:39', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2026-05-15 00:09:39', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2026-05-15 00:09:39', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2026-05-15 00:09:39', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2026-05-15 00:09:39', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2026-05-15 00:09:39', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2026-05-15 00:09:39', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2026-05-15 00:09:39', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2026-05-15 00:09:39', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2026-05-15 00:09:39', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2026-05-15 00:09:39', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2026-05-15 00:09:39', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2026-05-15 00:09:39', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2000, 'AI内容管理', 0, 5, 'ai', NULL, '', '', 1, 0, 'M', '0', '0', '', 'magic-stick', 'admin', '2026-05-18 23:46:18', '', NULL, 'AI内容管理目录');
INSERT INTO `sys_menu` VALUES (2001, '模板管理', 2000, 1, 'template', 'system/template/index', '', '', 1, 0, 'C', '0', '0', 'system:template:list', 'edit', 'admin', '2026-05-18 23:46:18', 'admin', '2026-05-29 08:26:35', '模板管理菜单');
INSERT INTO `sys_menu` VALUES (2002, '模板分类', 2000, 2, 'template-category', 'system/template/category/index', '', '', 1, 0, 'C', '0', '0', 'system:template:list', 'build', 'admin', '2026-05-18 23:46:18', 'admin', '2026-05-29 08:26:02', '模板分类菜单');
INSERT INTO `sys_menu` VALUES (2003, '模板新增', 2001, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:template:add', '#', 'admin', '2026-05-18 23:46:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2004, '模板修改', 2001, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:template:edit', '#', 'admin', '2026-05-18 23:46:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2005, '模板删除', 2001, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:template:remove', '#', 'admin', '2026-05-18 23:46:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2006, '模板导出', 2001, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:template:export', '#', 'admin', '2026-05-18 23:46:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2007, '模板查询', 2001, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:template:query', '#', 'admin', '2026-05-19 00:49:17', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2008, '生图配置', 2000, 3, 'image-config', 'system/aiImageConfig/index', '', '', 1, 0, 'C', '0', '0', 'system:aiImageConfig:query', 'edit', 'admin', '2026-05-21 23:11:15', '', NULL, 'AI生图配置菜单');
INSERT INTO `sys_menu` VALUES (2009, '生图配置查询', 2008, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:aiImageConfig:query', '#', 'admin', '2026-05-21 23:11:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2010, '生图配置修改', 2008, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:aiImageConfig:edit', '#', 'admin', '2026-05-21 23:11:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2011, '模板标签', 2000, 4, 'template-tag', 'system/template/tag/index', '', '', 1, 0, 'C', '0', '0', 'system:template:list', 'skill', 'admin', '2026-05-29 01:07:30', '', NULL, '模板标签菜单');
INSERT INTO `sys_menu` VALUES (2012, '邀请记录', 2000, 5, 'invite-record', 'system/invite/index', '', '', 1, 0, 'C', '0', '0', 'system:invite:list', 'peoples', 'admin', '2026-05-29 17:10:54', '', NULL, '邀请记录菜单');
INSERT INTO `sys_menu` VALUES (2013, '邀请记录查询', 2012, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:invite:list', '#', 'admin', '2026-05-29 17:10:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2014, '邀请记录导出', 2012, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:invite:export', '#', 'admin', '2026-05-29 17:10:54', '', NULL, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2026-05-15 00:09:40', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2026-05-15 00:09:40', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (3, '若依开源框架介绍', '1', 0x3C703E3C7370616E207374796C653D22636F6C6F723A20726762283233302C20302C2030293B223EE9A1B9E79BAEE4BB8BE7BB8D3C2F7370616E3E3C2F703E3C703E3C666F6E7420636F6C6F723D2223333333333333223E52756F5969E5BC80E6BA90E9A1B9E79BAEE698AFE4B8BAE4BC81E4B89AE794A8E688B7E5AE9AE588B6E79A84E5908EE58FB0E8849AE6898BE69EB6E6A186E69EB6EFBC8CE4B8BAE4BC81E4B89AE68993E980A0E79A84E4B880E7AB99E5BC8FE8A7A3E586B3E696B9E6A188EFBC8CE9998DE4BD8EE4BC81E4B89AE5BC80E58F91E68890E69CACEFBC8CE68F90E58D87E5BC80E58F91E69588E78E87E38082E4B8BBE8A681E58C85E68BACE794A8E688B7E7AEA1E79086E38081E8A792E889B2E7AEA1E79086E38081E983A8E997A8E7AEA1E79086E38081E88F9CE58D95E7AEA1E79086E38081E58F82E695B0E7AEA1E79086E38081E5AD97E585B8E7AEA1E79086E380813C2F666F6E743E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE5B297E4BD8DE7AEA1E790863C2F7370616E3E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE38081E5AE9AE697B6E4BBBBE58AA13C2F7370616E3E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE380813C2F7370616E3E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE69C8DE58AA1E79B91E68EA7E38081E799BBE5BD95E697A5E5BF97E38081E6938DE4BD9CE697A5E5BF97E38081E4BBA3E7A081E7949FE68890E7AD89E58A9FE883BDE38082E585B6E4B8ADEFBC8CE8BF98E694AFE68C81E5A49AE695B0E68DAEE6BA90E38081E695B0E68DAEE69D83E99990E38081E59BBDE99985E58C96E380815265646973E7BC93E5AD98E38081446F636B6572E983A8E7BDB2E38081E6BB91E58AA8E9AA8CE8AF81E7A081E38081E7ACACE4B889E696B9E8AEA4E8AF81E799BBE5BD95E38081E58886E5B883E5BC8FE4BA8BE58AA1E380813C2F7370616E3E3C666F6E7420636F6C6F723D2223333333333333223EE58886E5B883E5BC8FE69687E4BBB6E5AD98E582A83C2F666F6E743E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE38081E58886E5BA93E58886E8A1A8E5A484E79086E7AD89E68A80E69CAFE789B9E782B9E380823C2F7370616E3E3C2F703E3C703E3C696D67207372633D2268747470733A2F2F666F727564612E67697465652E636F6D2F696D616765732F313737333933313834383334323433393033322F61346432323331335F313831353039352E706E6722207374796C653D2277696474683A20363470783B223E3C62723E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A20726762283233302C20302C2030293B223EE5AE98E7BD91E58F8AE6BC94E7A4BA3C2F7370616E3E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE88BA5E4BE9DE5AE98E7BD91E59CB0E59D80EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F72756F79692E7669703C2F613E3C6120687265663D22687474703A2F2F72756F79692E76697022207461726765743D225F626C616E6B223E3C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE88BA5E4BE9DE69687E6A1A3E59CB0E59D80EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F646F632E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F646F632E72756F79692E7669703C2F613E3C62723E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E4B88DE58886E7A6BBE78988E38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F64656D6F2E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F64656D6F2E72756F79692E7669703C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E58886E7A6BBE78988E69CACE38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F7675652E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F7675652E72756F79692E7669703C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E5BEAEE69C8DE58AA1E78988E38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F636C6F75642E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F636C6F75642E72756F79692E7669703C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E7A7BBE58AA8E7ABAFE78988E38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F68352E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F68352E72756F79692E7669703C2F613E3C2F703E3C703E3C6272207374796C653D22636F6C6F723A207267622834382C2034392C203531293B20666F6E742D66616D696C793A202671756F743B48656C766574696361204E6575652671756F743B2C2048656C7665746963612C20417269616C2C2073616E732D73657269663B20666F6E742D73697A653A20313270783B223E3C2F703E, '0', 'admin', '2026-05-15 00:09:40', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_notice_read
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice_read`;
CREATE TABLE `sys_notice_read`  (
  `read_id` bigint NOT NULL AUTO_INCREMENT COMMENT '已读主键',
  `notice_id` int NOT NULL COMMENT '公告id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `read_time` datetime NOT NULL COMMENT '阅读时间',
  PRIMARY KEY (`read_id`) USING BTREE,
  UNIQUE INDEX `uk_user_notice`(`user_id` ASC, `notice_id` ASC) USING BTREE COMMENT '同一用户同一公告只记录一次'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '公告已读记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice_read
-- ----------------------------

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 157 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '模板管理', 1, 'com.ruoyi.web.controller.system.AiTemplateController.add()', 'POST', 1, 'admin', '研发部门', '/system/template', '127.0.0.1', '内网IP', '{\"aiEngine\":\"V2.4 模型\",\"category\":\"3\",\"coverUrl\":\"/profile/upload/2026/05/19/Snipaste_2026-05-18_22-06-28_20260519001618A001.png\",\"createBy\":\"admin\",\"params\":{},\"prompt\":\"12\",\"ratio\":\"1:1\",\"sort\":0,\"status\":\"0\",\"templateId\":100,\"title\":\"3\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 00:16:25', 94);
INSERT INTO `sys_oper_log` VALUES (101, '模板管理', 2, 'com.ruoyi.web.controller.system.AiTemplateController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/template', '127.0.0.1', '内网IP', '{\"aiEngine\":\"V2.4 模型\",\"categoryId\":2,\"categoryName\":\"水墨艺术\",\"coverUrl\":\"https://lh3.googleusercontent.com/aida-public/AB6AXuBy4Q9qzhm5vU8r8SAi7IiqgHBba2f1v9frjXOycyfWXX6vCQc4OZgvCJVa8uRoqk_wBWQB1jEe-TP7w1qna1bo_nmz51GR9DyemGINyF8YWag-aKtwur1m5QjuojukeXFL3yKVD_bSs9Gw9WURfyY2WQ3pgIp2u0NHtFZc7bBpG22O-KUhWxhvapU72CV4OlqbFLilBazCO3u0ZoJC0cCD09ggyxU1QgMn2rFE8QvDS_dPMgawbYdKGa7Cyt9RSyvOpC4KNcQpKj4_\",\"createBy\":\"admin\",\"createTime\":\"2026-05-19 00:40:48\",\"description\":\"有机水墨质感\",\"params\":{},\"prompt\":\"Organic black ink textures blooming on handmade paper, layered washes, abstract natural forms, elegant Chinese ink painting mood, high contrast, refined composition. ookk\",\"ratio\":\"1:1\",\"sort\":2,\"status\":\"0\",\"templateId\":2,\"title\":\"深墨之妙\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 00:52:37', 20);
INSERT INTO `sys_oper_log` VALUES (102, '模板管理', 2, 'com.ruoyi.web.controller.system.AiTemplateController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/template', '127.0.0.1', '内网IP', '{\"aiEngine\":\"V2.4 模型\",\"categoryId\":3,\"categoryName\":\"超现实\",\"coverUrl\":\"/profile/upload/2026/05/19/Snipaste_2026-05-17_19-52-36_20260519010532A001.png\",\"createBy\":\"admin\",\"createTime\":\"2026-05-19 00:40:48\",\"description\":\"3D 超现实主义\",\"params\":{},\"prompt\":\"Futuristic surreal 3D structure, impossible architectural forms, polished surfaces, dramatic studio lighting, abstract spatial depth, high-end concept art.\",\"ratio\":\"4:3\",\"sort\":4,\"status\":\"0\",\"templateId\":4,\"title\":\"未来结构\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 01:05:33', 9);
INSERT INTO `sys_oper_log` VALUES (103, '模板管理', 2, 'com.ruoyi.web.controller.system.AiTemplateController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/template', '127.0.0.1', '内网IP', '{\"aiEngine\":\"V2.4 模型\",\"categoryId\":3,\"categoryName\":\"超现实\",\"coverUrl\":\"https://lh3.googleusercontent.com/aida-public/AB6AXuDg1wfvmjr27Z35iMy0xuxdbO88ziI23TJdPT0cf-4dN0__IH1OurtM4pHdBJbYSeACOYz_YzyVxKCFixJIbhkbHkUntzOzu_dglucTVxnTideDIwlzDCRqptOf9iAIWhQ2mJ2DkEjIc53u_3j7CREdvyLtnfzgm5u9F7UBS_QEK_6dPIULaOBMeG53jLzNU2B-SvWUniKhxBrB2b1_eQuYpRIA75Sx2BC0enE66CXtergZNJwS0BIWhczTRqOoCpCexFlPywMIkKN\",\"createBy\":\"admin\",\"createTime\":\"2026-05-19 01:16:22\",\"description\":\"3D 超现实主义\",\"params\":{},\"prompt\":\"Futuristic surreal 3D structure, impossible architectural forms, polished surfaces, dramatic studio lighting, abstract spatial depth, high-end concept art.\",\"ratio\":\"4:3\",\"sort\":4,\"status\":\"0\",\"templateId\":4,\"title\":\"未来结构\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 01:17:05', 13);
INSERT INTO `sys_oper_log` VALUES (104, '模板管理', 2, 'com.ruoyi.web.controller.system.AiTemplateController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/template', '127.0.0.1', '内网IP', '{\"aiEngine\":\"V2.4 模型\",\"categoryId\":3,\"categoryName\":\"超现实\",\"coverUrl\":\"/profile/upload/2026/05/19/Snipaste_2026-05-17_19-43-41_20260519011712A002.png\",\"createBy\":\"admin\",\"createTime\":\"2026-05-19 01:16:22\",\"description\":\"3D 超现实主义\",\"params\":{},\"prompt\":\"Futuristic surreal 3D structure, impossible architectural forms, polished surfaces, dramatic studio lighting, abstract spatial depth, high-end concept art.\",\"ratio\":\"4:3\",\"sort\":4,\"status\":\"0\",\"templateId\":4,\"title\":\"未来结构\",\"updateBy\":\"admin\",\"updateTime\":\"2026-05-19 01:17:05\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 01:17:13', 13);
INSERT INTO `sys_oper_log` VALUES (105, '模板管理', 1, 'com.ruoyi.web.controller.system.AiTemplateController.add()', 'POST', 1, 'admin', '研发部门', '/system/template', '127.0.0.1', '内网IP', '{\"aiEngine\":\"GPT image2\",\"categoryId\":100,\"coverUrl\":\"/profile/upload/2026/05/21/opennana-14302-0_20260521011246A001.jpg\",\"createBy\":\"admin\",\"description\":\"\",\"params\":{},\"prompt\":\"Limited edition sneaker release poster, sneakers levitating in mid-air, flame special effects background\",\"ratio\":\"1:1\",\"sort\":0,\"status\":\"0\",\"templateId\":100,\"title\":\"限量球鞋发售海报悬浮火焰背景\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-21 01:13:03', 98);
INSERT INTO `sys_oper_log` VALUES (106, '模板管理', 2, 'com.ruoyi.web.controller.system.AiTemplateController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/template', '127.0.0.1', '内网IP', '{\"aiEngine\":\"GPT image2\",\"categoryId\":100,\"categoryName\":\"海报与营销\",\"coverUrl\":\"/profile/upload/2026/05/21/opennana-14302-0_20260521011246A001.jpg\",\"createBy\":\"admin\",\"createTime\":\"2026-05-21 01:13:03\",\"description\":\"\",\"params\":{},\"prompt\":\"Limited edition sneaker release poster, sneakers levitating in mid-air, flame special effects background\",\"ratio\":\"3:4\",\"sort\":0,\"status\":\"0\",\"templateId\":100,\"title\":\"限量球鞋发售海报悬浮火焰背景\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-21 01:14:39', 9);
INSERT INTO `sys_oper_log` VALUES (107, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"activeProvider\":\"primary\",\"backupProvider\":{\"apiKey\":\"sk-ant-oat01-TreuJkePrRVBLbNv3yhT6jldXpYQWhHBsuwfIGpodeVIbS1iOqBbRlTHTTRExLko8fiuTDw9EucS-PvtU2yemsMx38NKDAA\",\"baseUrl\":\"https://dm-fox.rjj.cc/codex/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"backup\",\"providerName\":\"备用通道\",\"providerType\":\"openai-compatible\"},\"forceSize\":\"1024x1024\",\"forceSizeEnabled\":false,\"primaryProvider\":{\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"primary\",\"providerName\":\"GPT2IMAGE主通道\",\"providerType\":\"openai-compatible\"}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-22 01:27:38', 151);
INSERT INTO `sys_oper_log` VALUES (108, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"activeProvider\":\"primary\",\"backupProvider\":{\"apiKey\":\"sk-ant-oat01-TreuJkePrRVBLbNv3yhT6jldXpYQWhHBsuwfIGpodeVIbS1iOqBbRlTHTTRExLko8fiuTDw9EucS-PvtU2yemsMx38NKDAA\",\"baseUrl\":\"https://dm-fox.rjj.cc/codex/v1\",\"enabled\":false,\"model\":\"gpt-image-2\",\"providerCode\":\"backup\",\"providerName\":\"备用通道\",\"providerType\":\"openai-compatible\"},\"forceSize\":\"1024x1024\",\"forceSizeEnabled\":false,\"primaryProvider\":{\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"primary\",\"providerName\":\"GPT2IMAGE主通道\",\"providerType\":\"openai-compatible\"}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-22 01:43:25', 106);
INSERT INTO `sys_oper_log` VALUES (109, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"activeProvider\":\"primary\",\"backupProvider\":{\"apiKey\":\"sk-ant-oat01-TreuJkePrRVBLbNv3yhT6jldXpYQWhHBsuwfIGpodeVIbS1iOqBbRlTHTTRExLko8fiuTDw9EucS-PvtU2yemsMx38NKDAA\",\"baseUrl\":\"https://dm-fox.rjj.cc/codex/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"backup\",\"providerName\":\"备用通道\",\"providerType\":\"openai-compatible\"},\"forceSize\":\"1024x1024\",\"forceSizeEnabled\":false,\"primaryProvider\":{\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"primary\",\"providerName\":\"GPT2IMAGE主通道\",\"providerType\":\"openai-compatible\"}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-22 01:47:04', 107);
INSERT INTO `sys_oper_log` VALUES (110, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"activeProvider\":\"primary\",\"backupProvider\":{\"apiKey\":\"sk-ant-oat01-TreuJkePrRVBLbNv3yhT6jldXpYQWhHBsuwfIGpodeVIbS1iOqBbRlTHTTRExLko8fiuTDw9EucS-PvtU2yemsMx38NKDAA\",\"baseUrl\":\"https://dm-fox.rjj.cc/codex/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"backup\",\"providerName\":\"备用通道\",\"providerType\":\"openai-compatible\"},\"fallbackEnabled\":true,\"forceSize\":\"1024x1024\",\"forceSizeEnabled\":false,\"primaryProvider\":{\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"primary\",\"providerName\":\"GPT2IMAGE主通道\",\"providerType\":\"openai-compatible\"}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-22 20:31:35', 177);
INSERT INTO `sys_oper_log` VALUES (111, '模板管理', 3, 'com.ruoyi.web.controller.system.AiTemplateController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/template/1', '127.0.0.1', '内网IP', '[1] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-22 22:14:06', 57);
INSERT INTO `sys_oper_log` VALUES (112, '模板管理', 3, 'com.ruoyi.web.controller.system.AiTemplateController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/template/4', '127.0.0.1', '内网IP', '[4] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-22 22:14:09', 10);
INSERT INTO `sys_oper_log` VALUES (113, '模板管理', 3, 'com.ruoyi.web.controller.system.AiTemplateController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/template/3', '127.0.0.1', '内网IP', '[3] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-22 22:14:16', 15);
INSERT INTO `sys_oper_log` VALUES (114, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"backupProviderCode\":\"grsai\",\"enabled\":true,\"fallbackEnabled\":true,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"superapi\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"providerType\":\"openai-compatible\",\"remark\":\"默认 GPT 主通道\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"providerType\":\"grsai\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"nano-banana-2\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 14:47:39', 77);
INSERT INTO `sys_oper_log` VALUES (115, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"backupProviderCode\":\"grsai\",\"enabled\":true,\"fallbackEnabled\":true,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"superapi\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"nano-banana-2\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 16:07:18', 67);
INSERT INTO `sys_oper_log` VALUES (116, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"backupProviderCode\":\"grsai\",\"enabled\":false,\"fallbackEnabled\":true,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"superapi\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"nano-banana-2\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 16:31:32', 51);
INSERT INTO `sys_oper_log` VALUES (117, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"backupProviderCode\":\"grsai\",\"enabled\":false,\"fallbackEnabled\":true,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"superapi\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"nano-banana-2\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 16:35:27', 44);
INSERT INTO `sys_oper_log` VALUES (118, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"backupProviderCode\":\"grsai\",\"enabled\":true,\"fallbackEnabled\":true,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"superapi\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"nano-banana-2\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 16:37:30', 42);
INSERT INTO `sys_oper_log` VALUES (119, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"nano-banana-2\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 16:38:27', 45);
INSERT INTO `sys_oper_log` VALUES (120, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"backupProviderCode\":\"superapi\",\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"nano-banana-2\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 16:38:36', 45);
INSERT INTO `sys_oper_log` VALUES (121, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"backupProviderCode\":\"superapi\",\"enabled\":true,\"fallbackEnabled\":true,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"nano-banana-2\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 16:39:14', 35);
INSERT INTO `sys_oper_log` VALUES (122, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"backupProviderCode\":\"superapi\",\"enabled\":true,\"fallbackEnabled\":true,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"nano-banana-2\",\"gpt-image-2-vip\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 16:50:21', 37);
INSERT INTO `sys_oper_log` VALUES (123, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"backupProviderCode\":\"superapi\",\"enabled\":true,\"fallbackEnabled\":true,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 17:08:08', 49);
INSERT INTO `sys_oper_log` VALUES (124, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"backupProviderCode\":\"superapi\",\"enabled\":true,\"fallbackEnabled\":true,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\",\"nano-banana-pro\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 17:08:55', 37);
INSERT INTO `sys_oper_log` VALUES (125, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"backupProviderCode\":\"superapi\",\"enabled\":true,\"fallbackEnabled\":true,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\",\"nano-banana-pro\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-25 23:33:44', 80);
INSERT INTO `sys_oper_log` VALUES (126, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"backupProviderCode\":\"superapi\",\"enabled\":true,\"fallbackEnabled\":true,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\",\"nano-banana-pro\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-26 01:36:10', 55);
INSERT INTO `sys_oper_log` VALUES (127, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"backupProviderCode\":\"superapi\",\"enabled\":true,\"fallbackEnabled\":true,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\",\"nano-banana-pro\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-26 01:36:49', 37);
INSERT INTO `sys_oper_log` VALUES (128, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"superapi\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\",\"nano-banana-pro\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-26 19:18:53', 83);
INSERT INTO `sys_oper_log` VALUES (129, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"superapi\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\",\"nano-banana-pro\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-26 19:19:38', 47);
INSERT INTO `sys_oper_log` VALUES (130, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"superapi\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\",\"nano-banana-pro\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-26 19:20:13', 46);
INSERT INTO `sys_oper_log` VALUES (131, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"superapi\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"superapi\",\"remark\":\"\",\"sortOrder\":3}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\",\"nano-banana-pro\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-26 19:20:30', 39);
INSERT INTO `sys_oper_log` VALUES (132, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"superapi\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\",\"nano-banana-pro\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-26 19:21:30', 45);
INSERT INTO `sys_oper_log` VALUES (133, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\",\"nano-banana-pro\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-26 22:09:22', 75);
INSERT INTO `sys_oper_log` VALUES (134, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"superapi\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\",\"nano-banana-pro\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-26 22:13:16', 36);
INSERT INTO `sys_oper_log` VALUES (135, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"backupProviderCode\":\"grsai\",\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"superapi\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\",\"nano-banana-pro\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-26 22:20:24', 79);
INSERT INTO `sys_oper_log` VALUES (136, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"backupProviderCode\":\"grsai\",\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"superapi\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"json\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\",\"nano-banana-pro\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-26 22:20:57', 37);
INSERT INTO `sys_oper_log` VALUES (137, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"backupProviderCode\":\"grsai\",\"enabled\":true,\"fallbackEnabled\":true,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"superapi\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"json\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\",\"nano-banana-pro\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-26 22:21:33', 35);
INSERT INTO `sys_oper_log` VALUES (138, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"backupProviderCode\":\"grsai\",\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"superapi\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"json\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\",\"nano-banana-pro\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-26 22:35:50', 28);
INSERT INTO `sys_oper_log` VALUES (139, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"backupProviderCode\":\"grsai\",\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"superapi\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"]},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\",\"nano-banana-pro\"]}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-26 22:36:16', 39);
INSERT INTO `sys_oper_log` VALUES (140, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"backupProviderCode\":\"grsai\",\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"superapi\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"],\"supportsBatch\":true},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\",\"nano-banana-pro\"],\"supportsBatch\":false}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-26 23:41:38', 58);
INSERT INTO `sys_oper_log` VALUES (141, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"],\"supportsBatch\":true},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\",\"nano-banana-pro\"],\"supportsBatch\":false}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-26 23:43:53', 34);
INSERT INTO `sys_oper_log` VALUES (142, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3}],\"outputCompression\":90,\"outputFormat\":\"png\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"],\"supportsBatch\":true},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\",\"nano-banana-pro\"],\"supportsBatch\":false}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-27 01:22:07', 53);
INSERT INTO `sys_oper_log` VALUES (143, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"],\"supportsBatch\":true},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana-2\",\"nano-banana-pro\"],\"supportsBatch\":false}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-27 01:22:26', 44);
INSERT INTO `sys_oper_log` VALUES (144, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 暂时走 Grsai\",\"sortOrder\":3},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-pro\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana-pro 暂时走 Grsai\",\"sortOrder\":5}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerModelMap\":{\"gpt-image-2\":\"gpt-image-2\"},\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"],\"supportsBatch\":true},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerModelMap\":{\"gpt-image-2\":\"gpt-image-2\",\"gpt-image-2-vip\":\"gpt-image-2-vip\",\"nano-banana\":\"nano-banana-fast\",\"nano-banana-2\":\"nano-banana-2\",\"nano-banana-pro\":\"nano-banana-pro\"},\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana\",\"nano-banana-2\",\"nano-banana-pro\"],\"supportsBatch\":false}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 09:32:47', 87);
INSERT INTO `sys_oper_log` VALUES (145, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelRoutes\":[{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 暂时走 Grsai\",\"sortOrder\":3},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-pro\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana-pro 暂时走 Grsai\",\"sortOrder\":5}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerModelMap\":{\"gpt-image-2\":\"gpt-image-2\"},\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"],\"supportsBatch\":true},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerModelMap\":{\"gpt-image-2\":\"gpt-image-2\",\"gpt-image-2-vip\":\"gpt-image-2-vip\",\"nano-banana\":\"nano-banana-fast\",\"nano-banana-2\":\"nano-banana-2\",\"nano-banana-pro\":\"nano-banana-pro\"},\"providerName\":\"Grsai 中转站\",\"remark\":\"支持 GPT 与 nano-banana 的中转站\",\"responseMode\":\"json\",\"sortOrder\":2,\"supportedModels\":[\"gpt-image-2\",\"gpt-image-2-vip\",\"nano-banana\",\"nano-banana-2\",\"nano-banana-pro\"],\"supportsBatch\":false}]} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 09:33:56', 52);
INSERT INTO `sys_oper_log` VALUES (146, '参数管理', 2, 'com.ruoyi.web.controller.system.SysConfigController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/config', '127.0.0.1', '内网IP', '{\"configId\":122,\"configKey\":\"ai.image.pricing.resolutionMultipliers\",\"configName\":\"AI生图-清晰度倍率\",\"configType\":\"Y\",\"configValue\":\"{\\\"1K\\\":1.0,\\\"2K\\\":1.2,\\\"4K\\\":1.5,\\\"8K\\\":2}\",\"createBy\":\"admin\",\"createTime\":\"2026-05-28 13:31:27\",\"params\":{},\"remark\":\"图片生成清晰度积分倍率\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 14:08:40', 18);
INSERT INTO `sys_oper_log` VALUES (147, '参数管理', 2, 'com.ruoyi.web.controller.system.SysConfigController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/config', '127.0.0.1', '内网IP', '{\"configId\":122,\"configKey\":\"ai.image.pricing.resolutionMultipliers\",\"configName\":\"AI生图-清晰度倍率\",\"configType\":\"Y\",\"configValue\":\"{\\\"1K\\\":1.0,\\\"2K\\\":1.2,\\\"4K\\\":1.5,\\\"8K\\\":2}\",\"createBy\":\"admin\",\"createTime\":\"2026-05-28 13:31:27\",\"params\":{},\"remark\":\"图片生成清晰度积分倍率\",\"updateBy\":\"admin\",\"updateTime\":\"2026-05-28 14:08:40\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 14:09:36', 11);
INSERT INTO `sys_oper_log` VALUES (148, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelPricings\":[{\"baseCredits\":6,\"enabled\":true,\"model\":\"gpt-image-2\",\"remark\":\"全能艺术创作\",\"sortOrder\":1},{\"baseCredits\":15,\"enabled\":true,\"model\":\"gpt-image-2-vip\",\"remark\":\"尺寸增强\",\"sortOrder\":2},{\"baseCredits\":5,\"enabled\":true,\"model\":\"nano-banana\",\"remark\":\"轻量快速生成\",\"sortOrder\":3},{\"baseCredits\":12,\"enabled\":true,\"model\":\"nano-banana-2\",\"remark\":\"写实摄影风格\",\"sortOrder\":4},{\"baseCredits\":20,\"enabled\":true,\"model\":\"nano-banana-pro\",\"remark\":\"专业细节增强\",\"sortOrder\":5}],\"modelRoutes\":[{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 暂时走 Grsai\",\"sortOrder\":3},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-pro\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana-pro 暂时走 Grsai\",\"sortOrder\":5}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerModelMap\":{\"gpt-image-2\":\"gpt-image-2\"},\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"],\"supportsBatch\":true},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerModelMap\":{\"gpt-image-2\":\"gpt-image-2\",\"gpt-image-2-vip\":\"gpt-image-2-vip\",\"nano-banana\":\"nano-banana-fast\",\"na', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 14:18:34', 78);
INSERT INTO `sys_oper_log` VALUES (149, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelPricings\":[{\"baseCredits\":6,\"enabled\":true,\"model\":\"gpt-image-2\",\"remark\":\"全能艺术创作\",\"sortOrder\":1},{\"baseCredits\":13,\"enabled\":true,\"model\":\"gpt-image-2-vip\",\"remark\":\"尺寸增强\",\"sortOrder\":2},{\"baseCredits\":5,\"enabled\":true,\"model\":\"nano-banana\",\"remark\":\"轻量快速生成\",\"sortOrder\":3},{\"baseCredits\":12,\"enabled\":true,\"model\":\"nano-banana-2\",\"remark\":\"写实摄影风格\",\"sortOrder\":4},{\"baseCredits\":18,\"enabled\":true,\"model\":\"nano-banana-pro\",\"remark\":\"专业细节增强\",\"sortOrder\":5}],\"modelRoutes\":[{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 暂时走 Grsai\",\"sortOrder\":3},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-pro\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana-pro 暂时走 Grsai\",\"sortOrder\":5}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerModelMap\":{\"gpt-image-2\":\"gpt-image-2\"},\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"],\"supportsBatch\":true},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerModelMap\":{\"gpt-image-2\":\"gpt-image-2\",\"gpt-image-2-vip\":\"gpt-image-2-vip\",\"nano-banana\":\"nano-banana-fast\",\"na', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 15:26:51', 80);
INSERT INTO `sys_oper_log` VALUES (150, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelPricings\":[{\"baseCredits\":6,\"enabled\":true,\"model\":\"gpt-image-2\",\"remark\":\"全能艺术创作\",\"sortOrder\":1},{\"baseCredits\":13,\"enabled\":true,\"model\":\"gpt-image-2-vip\",\"remark\":\"尺寸增强\",\"sortOrder\":2},{\"baseCredits\":5,\"enabled\":true,\"model\":\"nano-banana\",\"remark\":\"轻量快速生成\",\"sortOrder\":3},{\"baseCredits\":12,\"enabled\":true,\"model\":\"nano-banana-2\",\"remark\":\"写实摄影风格\",\"sortOrder\":4},{\"baseCredits\":18,\"enabled\":true,\"model\":\"nano-banana-pro\",\"remark\":\"专业细节增强\",\"sortOrder\":5}],\"modelRoutes\":[{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 暂时走 Grsai\",\"sortOrder\":3},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-pro\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana-pro 暂时走 Grsai\",\"sortOrder\":5}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerModelMap\":{\"gpt-image-2\":\"gpt-image-2\"},\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"],\"supportsBatch\":true},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerModelMap\":{\"gpt-image-2\":\"gpt-image-2\",\"gpt-image-2-vip\":\"gpt-image-2-vip\",\"nano-banana\":\"nano-banana-fast\",\"na', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 16:35:30', 80);
INSERT INTO `sys_oper_log` VALUES (151, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelPricings\":[{\"baseCredits\":6,\"enabled\":true,\"model\":\"gpt-image-2\",\"remark\":\"全能艺术创作\",\"sortOrder\":1},{\"baseCredits\":13,\"enabled\":true,\"model\":\"gpt-image-2-vip\",\"remark\":\"尺寸增强\",\"sortOrder\":2},{\"baseCredits\":5,\"enabled\":true,\"model\":\"nano-banana\",\"remark\":\"轻量快速生成\",\"sortOrder\":3},{\"baseCredits\":12,\"enabled\":true,\"model\":\"nano-banana-2\",\"remark\":\"写实摄影风格\",\"sortOrder\":4},{\"baseCredits\":18,\"enabled\":true,\"model\":\"nano-banana-pro\",\"remark\":\"专业细节增强\",\"sortOrder\":5}],\"modelRoutes\":[{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 暂时走 Grsai\",\"sortOrder\":3},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-pro\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana-pro 暂时走 Grsai\",\"sortOrder\":5}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerModelMap\":{\"gpt-image-2\":\"gpt-image-2\"},\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"],\"supportsBatch\":true},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerModelMap\":{\"gpt-image-2\":\"gpt-image-2\",\"gpt-image-2-vip\":\"gpt-image-2-vip\",\"nano-banana\":\"nano-banana-fast\",\"na', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 16:35:38', 48);
INSERT INTO `sys_oper_log` VALUES (152, 'AI生图配置', 2, 'com.ruoyi.web.controller.system.AiImageConfigController.updateConfig()', 'PUT', 1, 'admin', '研发部门', '/system/ai-image-config', '127.0.0.1', '内网IP', '{\"circuitBreakerCooldownMinutes\":10,\"circuitBreakerFailureThreshold\":3,\"modelPricings\":[{\"baseCredits\":6,\"enabled\":true,\"model\":\"gpt-image-2\",\"remark\":\"全能艺术创作\",\"sortOrder\":1},{\"baseCredits\":13,\"enabled\":true,\"model\":\"gpt-image-2-vip\",\"remark\":\"尺寸增强\",\"sortOrder\":2},{\"baseCredits\":5,\"enabled\":true,\"model\":\"nano-banana\",\"remark\":\"轻量快速生成\",\"sortOrder\":3},{\"baseCredits\":12,\"enabled\":true,\"model\":\"nano-banana-2\",\"remark\":\"写实摄影风格\",\"sortOrder\":4},{\"baseCredits\":18,\"enabled\":true,\"model\":\"nano-banana-pro\",\"remark\":\"专业细节增强\",\"sortOrder\":5},{\"baseCredits\":6,\"enabled\":true,\"model\":\"11\",\"remark\":\"1\",\"sortOrder\":6}],\"modelRoutes\":[{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"GPT 主用 SuperAPI，失败切 Grsai\",\"sortOrder\":1},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-2\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 固定走 Grsai\",\"sortOrder\":2},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"gpt-image-2-vip\",\"primaryProviderCode\":\"grsai\",\"remark\":\"\",\"sortOrder\":3},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana 暂时走 Grsai\",\"sortOrder\":3},{\"enabled\":true,\"fallbackEnabled\":false,\"model\":\"nano-banana-pro\",\"primaryProviderCode\":\"grsai\",\"remark\":\"nano-banana-pro 暂时走 Grsai\",\"sortOrder\":5}],\"outputCompression\":90,\"outputFormat\":\"jpeg\",\"providers\":[{\"adapterType\":\"openai-compatible\",\"apiKey\":\"g2i_nbY7_WUJ-cgx0UZkc93X-HHuQuWV7vuQ17P_0ykXc08\",\"baseUrl\":\"https://gpt2image.superapi.buzz/v1\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"superapi\",\"providerModelMap\":{\"gpt-image-2\":\"gpt-image-2\"},\"providerName\":\"SuperAPI 中转站\",\"remark\":\"默认 GPT 主通道\",\"responseMode\":\"stream\",\"sortOrder\":1,\"supportedModels\":[\"gpt-image-2\"],\"supportsBatch\":true},{\"adapterType\":\"grsai-async\",\"apiKey\":\"sk-8bf47400c7774296a2b52b9f24623d95\",\"baseUrl\":\"https://grsai.dakka.com.cn\",\"enabled\":true,\"model\":\"gpt-image-2\",\"providerCode\":\"grsai\",\"providerModelMap\":{\"gpt-image-2\":\"gpt-image-2\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-28 20:57:55', 64);
INSERT INTO `sys_oper_log` VALUES (153, '模板管理', 2, 'com.ruoyi.web.controller.system.AiTemplateController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/template', '127.0.0.1', '内网IP', '{\"aiEngine\":\"GPT image2\",\"categoryId\":100,\"categoryName\":\"海报与营销\",\"coverUrl\":\"/profile/upload/2026/05/21/opennana-14302-0_20260521011246A001.jpg\",\"createBy\":\"admin\",\"createTime\":\"2026-05-21 01:13:03\",\"description\":\"\",\"params\":{},\"prompt\":\"Limited edition sneaker release poster, sneakers levitating in mid-air, flame special effects background\",\"ratio\":\"3:4\",\"sort\":0,\"status\":\"0\",\"tagIds\":[4,5],\"tags\":[],\"templateId\":100,\"title\":\"限量球鞋发售海报悬浮火焰背景\",\"updateBy\":\"admin\",\"updateTime\":\"2026-05-21 01:14:39\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-29 01:16:57', 20);
INSERT INTO `sys_oper_log` VALUES (154, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/template/category/index\",\"createTime\":\"2026-05-18 23:46:18\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"模板分类\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"template-category\",\"perms\":\"system:template:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-29 08:26:02', 29);
INSERT INTO `sys_oper_log` VALUES (155, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/template/index\",\"createTime\":\"2026-05-18 23:46:18\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"模板管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"template\",\"perms\":\"system:template:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-29 08:26:35', 12);
INSERT INTO `sys_oper_log` VALUES (156, '邀请记录', 5, 'com.ruoyi.web.controller.system.AiInviteRecordController.export()', 'POST', 1, 'admin', '研发部门', '/system/invite/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2026-05-29 17:11:16', 550);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '岗位信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2026-05-15 00:09:39', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2026-05-15 00:09:39', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2026-05-15 00:09:39', '', NULL, '普通角色');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和部门关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);
INSERT INTO `sys_role_menu` VALUES (2, 2008);
INSERT INTO `sys_role_menu` VALUES (2, 2009);
INSERT INTO `sys_role_menu` VALUES (2, 2010);
INSERT INTO `sys_role_menu` VALUES (2, 2011);
INSERT INTO `sys_role_menu` VALUES (2, 2012);
INSERT INTO `sys_role_menu` VALUES (2, 2013);
INSERT INTO `sys_role_menu` VALUES (2, 2014);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `openid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '微信小程序openid',
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `idx_sys_user_openid`(`openid` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 104 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-05-29 16:56:38', '2026-05-15 00:09:39', 'admin', '2026-05-15 00:09:39', '', NULL, '管理员', NULL);
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-05-15 00:09:39', '2026-05-15 00:09:39', 'admin', '2026-05-15 00:09:39', '', NULL, '测试员', NULL);
INSERT INTO `sys_user` VALUES (102, NULL, 'wx_oVMxG3WK5WzkeOdMDY74', '灵感画师', '00', '', '', '2', '', '$2a$10$Y38iMrobXKM5hmtRAx0uXezIdaBZfIrV.j.rVkw4xgnK7HjZ3MEXC', '0', '0', '192.168.31.34', '2026-05-17 14:30:41', NULL, '', '2026-05-17 02:06:01', '', NULL, NULL, 'oVMxG3WK5WzkeOdMDY747x7G5JPo');
INSERT INTO `sys_user` VALUES (103, NULL, 'wx_oSfJ5V2FCF31A3DBxB2I', '奇想造梦', '00', '', '', '2', '', '$2a$10$WJobOIfAI1q6wfVK.bGdxehSdZnIC1qyd0k3b9J4.nXxkCWml5Roi', '0', '0', '192.168.124.41', '2026-05-29 15:56:20', NULL, '', '2026-05-18 22:57:15', '', NULL, NULL, 'o_SfJ5V2FCF31A3DBxB2I3rhBMoA');

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);

SET FOREIGN_KEY_CHECKS = 1;
