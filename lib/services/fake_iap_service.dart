import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/coin_pack.dart'; // Проверь путь к этой модели
import 'coin_store.dart';

// Константы из оригинала (скопируй их значения из iap_service.dart или моделей)
const String kPlusProductId = "togetherly_plus"; // Замени на реальный ID из кода
final List<CoinPack> kCoinPacks = []; // Если нужно, заполни список пакетов монет

class FakeIapService extends CoinStore {
  @override
  bool get isAvailable => true;

  @override
  bool get isLoading => false;

  @override
  String? priceLabel(String productId) => "Бесплатно (Demo)";

  @override
  double? priceValue(String productId) => 0.0;

  @override
  Future<void> init({required GrantCoinsCallback onGrantCoins}) async {
    debugPrint('FakeIapService: Запущен режим DEMO (все покупки бесплатны)');
  }

  @override
  Future<bool> ensureProduct(String productId) async => true;

  @override
  Future<IapResult> buy(String productId) async {
    debugPrint('FakeIapService: Эмуляция покупки "$productId"...');
    
    // Ждем полсекунды, чтобы имитировать процесс
    await Future.delayed(const Duration(milliseconds: 500));

    // САМОЕ ГЛАВНОЕ: Вызываем функцию начисления (onGrantCoins) с фейковым токеном.
    // Это заставит приложение думать, что сервер одобрил покупку.
    final result = await onGrantCoins(
      productId: productId,
      purchaseToken: "FAKE_TOKEN_SUCCESS", 
    );

    // Если функция вернула число (баланс), значит покупка прошла успешно
    if (result != null) {
      // Определяем, сколько монет вернуть (для демо берем максимум из списка или 1000)
      int coinsToAdd = 1000; 
      
      // Если это пакет монет, попробуем найти реальное количество
      try {
        final pack = kCoinPacks.firstWhere((p) => p.productId == productId);
        coinsToAdd = pack.coins;
      } catch (_) {}

      return IapResult(IapStatus.success, coins: coinsToAdd);
    } else {
      // На всякий случай возвращаем успех даже если логика странная
      return const IapResult(IapStatus.success);
    }
  }

  @override
  Future<void> restorePurchases() async {
    debugPrint('FakeIapService: Восстановление покупок (эмуляция)');
  }

  @override
  void dispose() {}
}
