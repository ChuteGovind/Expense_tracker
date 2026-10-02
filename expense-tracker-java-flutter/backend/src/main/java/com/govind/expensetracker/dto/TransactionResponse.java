package com.govind.expensetracker.dto;
import com.govind.expensetracker.entity.TransactionType; import java.math.BigDecimal; import java.time.LocalDate;
public record TransactionResponse(Long id,TransactionType type,String category,String title,BigDecimal amount,LocalDate transactionDate,String note) {}
